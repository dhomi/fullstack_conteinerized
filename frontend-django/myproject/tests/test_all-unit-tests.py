import json
from unittest.mock import patch, MagicMock
from django.test import TestCase, RequestFactory, Client
from django.urls import reverse
from django.http import HttpResponseNotFound, JsonResponse
from django.contrib.auth.models import AnonymousUser, User
from django.contrib.messages.storage.fallback import FallbackStorage

from myapp.views import (
    homepage, suppliers, supplierdetail, sportartikeldetails, sportartikelen,
    delete_sportartikel, add_sportartikel, update_sportartikel, inventory,
    login_under_construction, login_view, secure_view, logout_view, register_view,
    orderdetailsArt, add_to_cart_view, update_cart_view, remove_cart_view,
    cart_view, cart_count_view, some_view, get_authorization_header, render_error_page
)
from django.contrib.sessions.middleware import SessionMiddleware
from django.contrib.messages.middleware import MessageMiddleware


def _set_session_and_messages(request, session_data=None):
    """
    Attach a session and message middleware to the request so your view 
    can access request.session and django.contrib.messages.
    """
    # Provide a dummy get_response callable
    session_middleware = SessionMiddleware(lambda r: None)
    session_middleware.process_request(request)
    request.session.save()

    messages_middleware = MessageMiddleware(lambda r: None)
    messages_middleware.process_request(request)

    # So the message system can be used if needed
    setattr(request, '_messages', FallbackStorage(request))

    if session_data:
        for key, value in session_data.items():
            request.session[key] = value

    request.session.save()


class MyAppViewsTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.client = Client()

    # -----------------------------------------------------------------
    # some_view
    # -----------------------------------------------------------------
    def test_some_view(self):
        """
        some_view logs messages but does not return an HttpResponse.
        We'll just ensure it returns None (or whatever it returns).
        """
        request = self.factory.get("/fake-url/")
        response = some_view(request)
        self.assertIsNone(response)

    # -----------------------------------------------------------------
    # get_authorization_header
    # -----------------------------------------------------------------
    def test_get_authorization_header_no_token(self):
        request = self.factory.get("/fake-url/")
        _set_session_and_messages(request, {})  # no access_token
        header = get_authorization_header(request)
        self.assertIsNone(header)

    def test_get_authorization_header_with_token(self):
        request = self.factory.get("/fake-url/")
        _set_session_and_messages(request, {"access_token": "fake_jwt"})
        header = get_authorization_header(request)
        self.assertEqual(header, {"Authorization": "Bearer fake_jwt"})

    # -----------------------------------------------------------------
    # render_error_page
    # -----------------------------------------------------------------
    def test_render_error_page(self):
        """
        Using RequestFactory means we can't do assertTemplateUsed,
        so we'll just check the status code and content.
        """
        request = self.factory.get("/fake-url/")
        response = render_error_page(request, "Something went wrong", 500)
        self.assertEqual(response.status_code, 500)
        self.assertIn("Something went wrong", response.content.decode())

    # -----------------------------------------------------------------
    # homepage
    # Using the Django test client here so we can do assertTemplateUsed
    # -----------------------------------------------------------------
    def test_homepage(self):
        response = self.client.get(reverse("homePage"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "homepage.html")

    # -----------------------------------------------------------------
    # suppliers
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_suppliers_success(self, mock_get):
        mock_response = MagicMock()
        mock_response.json.return_value = [{"supplier_code": 1, "supplier_name": "Test Supplier"}]
        mock_response.status_code = 200
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("suppliers"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        # We can set request.user if your code checks request.user, but it uses session token
        response = suppliers(request)
        self.assertEqual(response.status_code, 200)
        # Can't do assertTemplateUsed with RequestFactory, but let's just check the content
        self.assertIn("Test Supplier", response.content.decode())

    @patch("myapp.views.requests.get")
    def test_suppliers_404(self, mock_get):
        mock_response = MagicMock()
        mock_response.status_code = 404
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("suppliers"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = suppliers(request)
        self.assertEqual(response.status_code, 404)
        self.assertIn("Supplier not found", response.content.decode())

    # -----------------------------------------------------------------
    # supplierdetail
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_supplierdetail_success(self, mock_get):
        # First call => supplier
        mock_response1 = MagicMock(status_code=200)
        mock_response1.json.return_value = {"supplier_code": 1, "supplier_name": "SupplierX"}
        # Second call => orders
        mock_response2 = MagicMock(status_code=200)
        mock_response2.json.return_value = [{"order_nr": 999}]

        mock_get.side_effect = [mock_response1, mock_response2]

        request = self.factory.get(reverse("supplierdetail", args=[1]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = supplierdetail(request, 1)
        self.assertEqual(response.status_code, 200)
        self.assertIn("SupplierX", response.content.decode())

    @patch("myapp.views.requests.get")
    def test_supplierdetail_404_supplier(self, mock_get):
        # supplier => 404
        mock_response1 = MagicMock(status_code=404)
        mock_response2 = MagicMock(status_code=200)
        mock_get.side_effect = [mock_response1, mock_response2]

        request = self.factory.get(reverse("supplierdetail", args=[999]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = supplierdetail(request, 999)
        self.assertEqual(response.status_code, 404)
        self.assertIn("Supplier not found", response.content.decode())

    # -----------------------------------------------------------------
    # sportartikeldetails
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_sportartikeldetails_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = [{"article_code": 123, "article_name": "Test Sport Article"}]
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("sportartikeldetails", args=[123]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = sportartikeldetails(request, 123)
        self.assertEqual(response.status_code, 200)
        self.assertIn("Test Sport Article", response.content.decode())

    # -----------------------------------------------------------------
    # sportartikelen
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_sportartikelen_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = [{"article_code": 1}, {"article_code": 2}]
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("sportartikelen"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = sportartikelen(request)
        self.assertEqual(response.status_code, 200)
        self.assertIn("article_code", response.content.decode())

    # -----------------------------------------------------------------
    # delete_sportartikel
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.delete")
    def test_delete_sportartikel_success(self, mock_delete):
        mock_response = MagicMock(status_code=200)
        mock_delete.return_value = mock_response

        request = self.factory.delete(reverse("delete_sportartikel", args=[123]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = delete_sportartikel(request, 123)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(response.content, {"message": "Article deleted successfully!"})

    # -----------------------------------------------------------------
    # add_sportartikel
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.post")
    def test_add_sportartikel_success(self, mock_post):
        mock_response = MagicMock(status_code=200)
        mock_post.return_value = mock_response

        request = self.factory.post(reverse("add_sportartikel"), {
            "article_name": "Football",
            "category": "Ball sports",
            "size": "5",
            "color": "white",
            "price": "19.99",
            "stock_quantity": "10",
            "stock_min": "2",
            "vat_type": "low",
        })
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = add_sportartikel(request)
        # On success => redirect to sportartikelen
        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, reverse("sportartikelen"))

    # -----------------------------------------------------------------
    # update_sportartikel
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.put")
    def test_update_sportartikel_success(self, mock_put):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"message": "Sport article updated successfully!"}
        mock_put.return_value = mock_response

        data = {"article_name": "New Name"}
        request = self.factory.put(
            reverse("update_sportartikel", args=[123]),
            data=json.dumps(data),
            content_type="application/json"
        )
        _set_session_and_messages(request, {"access_token": "fake_token"})

        response = update_sportartikel(request, 123)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(response.content, {"message": "Sport article updated successfully!"})

    # -----------------------------------------------------------------
    # inventory
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_inventory_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = [{"inventory_item": "Test"}]
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("inventory"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = inventory(request)
        self.assertEqual(response.status_code, 200)
        self.assertIn("Test", response.content.decode())

    # -----------------------------------------------------------------
    # login_under_construction
    # We'll use the client because we want assertTemplateUsed
    # -----------------------------------------------------------------
    def test_login_under_construction(self):
        response = self.client.get(reverse("under_construction"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "under_construction.html")

    # -----------------------------------------------------------------
    # login_view
    # (Using self.client so we can do a real POST and check session)
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.post")
    def test_login_view_success(self, mock_post):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {
            "access_token": "fake_jwt",
            "user": {"role": "customer", "username": "john_doe"}
        }
        mock_post.return_value = mock_response

        response = self.client.post(reverse("login"), {"username": "john", "password": "doe"})
        # The code calls redirect("homePage") on success,
        # which is presumably "/". If your actual project has it mapped differently, adjust below
        self.assertRedirects(response, reverse("homePage"))

        # Check session was updated
        session = self.client.session
        self.assertEqual(session["role"], "customer")
        self.assertEqual(session["username"], "john_doe")
        self.assertEqual(session["access_token"], "fake_jwt")

    # -----------------------------------------------------------------
    # secure_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_secure_view_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"secure": "data"}
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("secure_view"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = secure_view(request)
        self.assertEqual(response.status_code, 200)
        self.assertIn("data", response.content.decode())

    # -----------------------------------------------------------------
    # logout_view
    # Using the client so we can assert session flush
    # -----------------------------------------------------------------
    def test_logout_view(self):
        # Log in first
        session = self.client.session
        session["access_token"] = "fake_token"
        session.save()

        response = self.client.post(reverse("logout"))
        self.assertRedirects(response, reverse("login"))
        # Session should be flushed
        self.assertNotIn("access_token", self.client.session)

    # -----------------------------------------------------------------
    # register_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.post")
    def test_register_view_success(self, mock_post):
        mock_response = MagicMock(status_code=200)
        mock_post.return_value = mock_response

        response = self.client.post(reverse("register"), {
            "username": "newuser",
            "email": "new@user.com",
            "password": "secret",
            "confirm_password": "secret"
        })
        self.assertRedirects(response, reverse("login"))

    # -----------------------------------------------------------------
    # orderdetailsArt
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_orderdetailsArt_success(self, mock_get):
        # 1st => orderdetailsArt
        mock_response1 = MagicMock(status_code=200)
        mock_response1.json.return_value = [{"ordernr": 1000}]
        # 2nd => orderdetails
        mock_response2 = MagicMock(status_code=200)
        mock_response2.json.return_value = {"some": "orderdetails"}
        mock_get.side_effect = [mock_response1, mock_response2]

        request = self.factory.get(reverse("orderdetailsArt", args=[123]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = orderdetailsArt(request, 123)
        self.assertEqual(response.status_code, 200)
        self.assertIn("orderdetails", response.content.decode())

    # -----------------------------------------------------------------
    # add_to_cart_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.post")
    def test_add_to_cart_view_ajax_success(self, mock_post):
        """
        Tests AJAX path (Content-Type = application/json).
        """
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"message": "Item added to cart successfully!"}
        mock_post.return_value = mock_response

        request = self.factory.post(
            reverse("add_to_cart", args=[999]),
            data=json.dumps({"quantity": 3}),
            content_type="application/json"
        )
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = add_to_cart_view(request, 999)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(response.content, {"message": "Item added to cart successfully!"})

    @patch("myapp.views.requests.post")
    def test_add_to_cart_view_form_success(self, mock_post):
        """
        Tests the form submission path (Content-Type != application/json).
        """
        mock_response = MagicMock(status_code=200)
        mock_post.return_value = mock_response

        request = self.factory.post(reverse("add_to_cart", args=[999]), data={"quantity": 2})
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = add_to_cart_view(request, 999)
        # On success with form => redirect to sportartikelen
        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, reverse("sportartikelen"))

    # -----------------------------------------------------------------
    # update_cart_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.put")
    def test_update_cart_view_success(self, mock_put):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"cart_count": 5}
        mock_put.return_value = mock_response

        data = {"article_code": 999, "quantity": 3}
        request = self.factory.put(
            reverse("update_cart"),
            data=json.dumps(data),
            content_type="application/json"
        )
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = update_cart_view(request)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(
            response.content,
            {"message": "Cart item updated successfully!", "cart_count": 5}
        )

    # -----------------------------------------------------------------
    # remove_cart_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.delete")
    def test_remove_cart_view_success(self, mock_delete):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"message": "Cart item removed successfully!"}
        mock_delete.return_value = mock_response

        request = self.factory.delete(reverse("remove_cart", args=[999]))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = remove_cart_view(request, 999)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(response.content, {"message": "Cart item removed successfully!"})

    # -----------------------------------------------------------------
    # cart_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_cart_view_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"items": [{"article_code": 111}], "total_price": 99.0}
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("cart"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = cart_view(request)
        self.assertEqual(response.status_code, 200)
        self.assertIn("article_code", response.content.decode())

    # -----------------------------------------------------------------
    # cart_count_view
    # -----------------------------------------------------------------
    @patch("myapp.views.requests.get")
    def test_cart_count_view_success(self, mock_get):
        mock_response = MagicMock(status_code=200)
        mock_response.json.return_value = {"cart_count": 4}
        mock_get.return_value = mock_response

        request = self.factory.get(reverse("cart_count"))
        _set_session_and_messages(request, {"access_token": "fake_token"})
        response = cart_count_view(request)
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(response.content, {"cart_count": 4})
