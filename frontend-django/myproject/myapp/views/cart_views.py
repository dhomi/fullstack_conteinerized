import requests
import json
import jwt
import logging
from myapp.utils import get_authorization_header, login_required
from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import JsonResponse, HttpResponseNotFound
from django.conf import settings
from django.views.decorators.http import require_POST, require_http_methods
from django.contrib.auth import logout
from jwt.exceptions import ExpiredSignatureError, InvalidTokenError

from myapp.utils import login_required  # custom login_required decorator

logger = logging.getLogger(__name__)

class CartViews:
    @staticmethod
    @login_required
    @require_POST
    def add_to_cart_view(request, article_code):
        """
        Django view to handle adding an article to the cart via AJAX or form submission.
        """
        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"detail": "You need to log in first!"}, status=401)

        # Determine if the request is AJAX or form submission based on content type
        if request.headers.get('Content-Type') == 'application/json':
            # AJAX request
            try:
                data = json.loads(request.body)
                quantity = data.get("quantity", 1)
            except json.JSONDecodeError:
                quantity = 1
        else:
            # Form submission
            quantity = request.POST.get("quantity", 1)

        try:
            quantity = int(quantity)
            if quantity < 1:
                raise ValueError
        except ValueError:
            return JsonResponse({"detail": "Invalid quantity specified."}, status=400)

        try:
            response = requests.post(
                f"{settings.API_HOST}/cart/add/",
                headers={
                    "Authorization": f"Bearer {token}",
                    "Content-Type": "application/json"
                },
                json={
                    "article_code": article_code,
                    "quantity": quantity
                },
                timeout=5
            )
        except requests.RequestException as e:
            logger.exception("Error connecting to FastAPI: %s", str(e))
            return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

        if response.status_code == 200:
            if request.headers.get('Content-Type') == 'application/json':
                return JsonResponse({"message": "Item added to cart successfully!"}, status=200)
            else:
                messages.success(request, "Item added to cart successfully!")
                return redirect("sportartikelen")
        else:
            try:
                error_detail = response.json().get("detail", "Failed to add to cart.")
            except json.JSONDecodeError:
                error_detail = "Failed to add to cart."
            if request.headers.get('Content-Type') == 'application/json':
                return JsonResponse({"detail": error_detail}, status=response.status_code)
            else:
                messages.error(request, f"Error: {error_detail}")
                return redirect("sportartikelen")

    @staticmethod
    @require_http_methods(["PUT"])
    def update_cart_view(request):
        """
        Django view to update the quantity of a cart item via AJAX.
        Expects JSON body with 'article_code' and 'quantity'.
        """
        try:
            data = json.loads(request.body)
            article_code = data.get("article_code")
            quantity = data.get("quantity")

            if not article_code or not isinstance(quantity, int) or quantity < 1:
                return JsonResponse({"detail": "Invalid request data."}, status=400)
        except json.JSONDecodeError:
            return JsonResponse({"detail": "Invalid JSON."}, status=400)

        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"detail": "You need to log in first!"}, status=401)

        try:
            response = requests.put(
                f"{settings.API_HOST}/cart/update/",
                headers={
                    "Authorization": f"Bearer {token}",
                    "Content-Type": "application/json"
                },
                json={
                    "article_code": article_code,
                    "quantity": quantity
                },
                timeout=5
            )
        except requests.RequestException as e:
            logger.exception("Error connecting to FastAPI: %s", str(e))
            return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

        if response.status_code == 200:
            resp_data = response.json()
            return JsonResponse({"message": "Cart item updated successfully!", "cart_count": resp_data.get("cart_count", 0)}, status=200)
        else:
            try:
                error_detail = response.json().get("detail", "Failed to update cart item.")
            except json.JSONDecodeError:
                error_detail = "Failed to update cart item."
            return JsonResponse({"detail": error_detail}, status=response.status_code)

    @staticmethod
    @require_http_methods(["DELETE"])
    def remove_cart_view(request, article_code):
        """
        Django view to remove an article from the cart via AJAX.
        """
        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"detail": "You need to log in first!"}, status=401)

        try:
            response = requests.delete(
                f"{settings.API_HOST}/cart/delete/{article_code}",
                headers={
                    "Authorization": f"Bearer {token}",
                    "Content-Type": "application/json"
                },
                timeout=5
            )
        except requests.RequestException as e:
            logger.exception("Error connecting to FastAPI: %s", str(e))
            return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

        if response.status_code == 200:
            return JsonResponse({"message": "Cart item removed successfully!"}, status=200)
        else:
            try:
                error_detail = response.json().get("detail", "Failed to remove cart item.")
            except json.JSONDecodeError:
                error_detail = "Failed to remove cart item."
            return JsonResponse({"detail": error_detail}, status=response.status_code)

    @staticmethod
    @login_required
    def cart_view(request):
        """
        Django view to display the user's cart.
        Fetches cart items from FastAPI.
        """
        token = request.session.get("access_token")
        if not token:
            messages.error(request, "You need to log in to view your cart.")
            return redirect("login")

        try:
            response = requests.get(
                f"{settings.API_HOST}/cart/",
                headers={
                    "Authorization": f"Bearer {token}",
                    "Content-Type": "application/json"
                },
                timeout=5
            )
        except requests.RequestException as e:
            logger.exception("Error connecting to FastAPI: %s", str(e))
            messages.error(request, f"Error connecting to the server: {e}")
            return redirect("homePage")

        if response.status_code == 200:
            data = response.json()
            return render(request, "cart.html", {"cart": data})
        else:
            try:
                error_detail = response.json().get("detail", "Failed to retrieve cart.")
            except json.JSONDecodeError:
                error_detail = "Failed to retrieve cart."
            messages.error(request, f"Error: {error_detail}")
            return redirect("homePage")

    @staticmethod
    @login_required
    @require_http_methods(["GET"])
    def cart_count_view(request):
        """
        Django view to retrieve the current number of items in the user's cart.
        Returns a JSON response with the cart count.
        """
        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"detail": "You need to log in first!"}, status=401)

        try:
            response = requests.get(
                f"{settings.API_HOST}/cart/count/",
                headers={
                    "Authorization": f"Bearer {token}",
                    "Content-Type": "application/json"
                },
                timeout=5
            )
        except requests.RequestException as e:
            logger.exception("Error connecting to FastAPI: %s", str(e))
            return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

        if response.status_code == 200:
            data = response.json()
            cart_count = data.get("cart_count", 0)
            return JsonResponse({"cart_count": cart_count}, status=200)
        else:
            logger.error("Failed to retrieve cart count. Status code: %s", response.status_code)
            return JsonResponse({"cart_count": 0}, status=200)