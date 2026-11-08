import os
from flask import Flask, jsonify, request
import psycopg

app = Flask(__name__)
DATABASE_URL = os.environ["DATABASE_URL"]

@app.get("/health")
def health():
    return jsonify(status="ok"), 200

@app.get("/products")
def products():
    return jsonify([
        {"id": 1, "name": "Laptop", "price": 55000},
        {"id": 2, "name": "Headphones", "price": 2500}
    ])

@app.post("/orders")
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