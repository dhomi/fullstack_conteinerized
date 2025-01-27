# myapp/tests/test_registration.py

from django.test import TestCase, Client
from django.urls import reverse
from unittest.mock import patch
import json
from django.conf import settings
import jwt
from datetime import datetime, timedelta

class UserRegistrationTests(TestCase):
    @patch('myapp.views.requests.post')
    def test_register_user_success(self, mock_post):
        # Mock successful registration response from FastAPI
        mock_post.return_value.status_code = 200
        mock_post.return_value.json.return_value = {"message": "User registered successfully"}

        client = Client()
        response = client.post(reverse('register'), {
            "username": "newuser",
            "email": "newuser@example.com",
            "password": "newpassword123",
            "role": "customer"
        })
        self.assertRedirects(response, reverse('login'))
        messages = list(response.wsgi_request._messages)
        self.assertEqual(len(messages), 1)
        self.assertEqual(str(messages[0]), "Registration successful. Please log in.")

    @patch('myapp.views.requests.post')
    def test_register_user_existing_username(self, mock_post):
        # Mock failed registration due to existing username
        mock_post.return_value.status_code = 400
        mock_post.return_value.json.return_value = {"detail": "Username already exists"}

        client = Client()
        response = client.post(reverse('register'), {
            "username": "existinguser",
            "email": "newemail@example.com",
            "password": "newpassword123",
            "role": "customer"
        })
        self.assertEqual(response.status_code, 200)  # Form is re-rendered
        messages = list(response.wsgi_request._messages)
        self.assertEqual(len(messages), 1)
        self.assertEqual(str(messages[0]), "Error: Username already exists")
