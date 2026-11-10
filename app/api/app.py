import os
from flask import Flask, jsonify, request, Response
import psycopg
from prometheus_client import Counter, generate_latest

app = Flask(__name__)
DATABASE_URL = os.environ.get("DATABASE_URL", "")

# Prometheus Request Counter
REQUEST_COUNT = Counter(
    "shopsphere_requests_total",
    "Number of ShopSphere requests"
)

@app.before_request
def before_request():
    REQUEST_COUNT.inc()

@app.get("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype="text/plain; version=0.0.4"
    )

@app.route("/health", methods=["GET"])
@app.route("/api/health", methods=["GET"])
def health():
    return jsonify(status="ok"), 200

@app.route("/products", methods=["GET"])
@app.route("/api/products", methods=["GET"])
def products():
    return jsonify([
        {"id": 1, "name": "Laptop", "price": 55000},
        {"id": 2, "name": "Headphones", "price": 2500}
    ])

@app.route("/orders", methods=["POST"])
@app.route("/api/orders", methods=["POST"])
def create_order():
    data = request.get_json(silent=True) or {}
    product_id = data.get("product_id")
    quantity = data.get("quantity")
    if not isinstance(product_id, int) or not isinstance(quantity, int):
        return jsonify(error="product_id and quantity must be integers"), 400
    if product_id < 1 or quantity < 1:
        return jsonify(error="Values must be positive"), 400
    with psycopg.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """CREATE TABLE IF NOT EXISTS orders (
                    id BIGSERIAL PRIMARY KEY,
                    product_id INT NOT NULL,
                    quantity INT NOT NULL
                );"""
            )
            cur.execute(
                "INSERT INTO orders (product_id, quantity) VALUES (%s, %s) RETURNING id;",
                (product_id, quantity)
            )
            order_id = cur.fetchone()[0]
            conn.commit()
    return jsonify(id=order_id, product_id=product_id, quantity=quantity), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
