from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_register_user():
    # Arrange: Testdata voor registratie
    register_data = {
        "username": "testuser",
        "email": "testuser@example.com",
        "password": "testpassword"
    }

    # Act: Doe een POST-verzoek naar het register endpoint
    response = client.post("/users/register", json=register_data)

    # Assert: Controleer of de gebruiker succesvol is aangemaakt
    assert response.status_code == 200
    assert response.json()["message"] == "User registered successfully"

def test_login_user():
    # Arrange: Testdata voor login
    login_data = {
        "username": "testuser",
        "password": "testpassword"
    }

    # Act: Doe een POST-verzoek naar het login endpoint
    response = client.post("/users/login", data=login_data)

    # Assert: Controleer of de token is gegenereerd
    assert response.status_code == 200
    token = response.json().get("access_token")
    assert token is not None

    return token

def test_secure_endpoint():
    # Arrange: Haal de token op door in te loggen
    token = test_login_user()

    # Act: Doe een GET-verzoek naar een beveiligd endpoint
    response = client.get("/secure-data", headers={"Authorization": f"Bearer {token}"})

    # Assert: Controleer of toegang is verleend
    assert response.status_code == 200
    assert response.json()["message"] == "You have access to this secure data!"
