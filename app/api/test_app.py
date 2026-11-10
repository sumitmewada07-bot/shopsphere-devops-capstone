from app import app

def test_health():
    client = app.test_client()
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}

def test_products():
    client = app.test_client()
    response = client.get("/api/products")
    assert response.status_code == 200
    assert len(response.get_json()) >= 1
