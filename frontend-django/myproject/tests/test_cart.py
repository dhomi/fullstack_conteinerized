# myapp/tests/test_cart.py

from django.test import TestCase, Client
from django.urls import reverse
from unittest.mock import patch
from django.contrib.auth.models import User
import json
from django.conf import settings
import jwt
from datetime import datetime, timedelta

class CartViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        # Generate a valid JWT token with role 'customer'
        payload = {
            "user_id": self.user.id,
            "sub": self.user.username,
            "role": "customer",
            "exp": datetime.utcnow() + timedelta(minutes=30)
        }
        self.token = jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")
        # Set session data
        session = self.client.session
        session['access_token'] = self.token
        session['username'] = self.user.username
        session['role'] = 'customer'
        session.save()

    @patch('myapp.views.requests.get')
    def test_cart_view_success(self, mock_get):
        mock_cart = {
            "items": [
                {
                    "article_code": 101,
                    "article_name": "Soccer Ball",
                    "price": 29.99,
                    "quantity": 2,
                    "total_price": 59.98
                }
            ],
            "total_price": 59.98
        }
        mock_get.return_value.status_code = 200
        mock_get.return_value.json.return_value = mock_cart

        response = self.client.get(reverse('cart'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Soccer Ball")
        self.assertContains(response, "59.98")

    @patch('myapp.views.requests.get')
    def test_cart_view_api_failure(self, mock_get):
        mock_get.return_value.status_code = 500
        mock_get.return_value.json.return_value = {"detail": "Internal Server Error"}

        response = self.client.get(reverse('cart'))
        self.assertRedirects(response, reverse('homePage'))
        messages = list(response.wsgi_request._messages)
        self.assertEqual(len(messages), 1)
        self.assertEqual(str(messages[0]), "Error: Internal Server Error")
