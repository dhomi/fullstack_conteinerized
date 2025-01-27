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

class AuthViews:
    """
    Views related to authentication: login, logout, register, secure_view.
    """

    @staticmethod
    def login_view(request):
        if request.method == "POST":
            username = request.POST.get("username")
            password = request.POST.get("password")

            try:
                response = requests.post(
                    f"{settings.API_HOST}/users/login",
                    data={"username": username, "password": password},
                    timeout=5
                )
                if response.status_code == 200:
                    data = response.json()
                    access_token = data.get("access_token")
                    if access_token:
                        user_info = data.get("user", {})
                        user_role = user_info.get("role", None)
                        user_name = user_info.get("username", None)
                        
                        try:
                            decoded = jwt.decode(access_token, settings.SECRET_KEY, algorithms=["HS256"])
                            role = decoded.get("role")
                            if role:
                                request.session['role'] = role
                            else:
                                messages.error(request, "Invalid token: Missing role.")
                                return redirect("login")
                        except jwt.ExpiredSignatureError:
                            messages.error(request, "Token has expired.")
                            return redirect("login")
                        except jwt.InvalidTokenError:
                            messages.error(request, "Invalid token.")
                            return redirect("login")
                        except (ExpiredSignatureError, InvalidTokenError) as e:
                            messages.error(request, "Invalid or expired token.")
                            return redirect("login")

                        # Store to session
                        request.session["access_token"] = access_token
                        request.session["role"] = user_role  
                        request.session["username"] = user_name  
                        
                        return redirect("homePage")
                    else:
                        messages.error(request, "No access token returned by server.")
                        return redirect("login")
                else:
                    messages.error(request, "Invalid credentials.")
                    return redirect("login")
            except requests.RequestException as e:
                messages.error(request, f"Login error: {e}")
                return redirect("login")
        else:
            return render(request, "login.html")

    @staticmethod
    def logout_view(request):
        """
        Logout view to clear session and redirect to login page.
        """
        request.session.flush()
        messages.success(request, "You have been successfully logged out.")
        return redirect("login")

    @staticmethod
    def register_view(request):
        """
        User registration view.
        """
        if request.method == "POST":
            username = request.POST.get("username")
            email = request.POST.get("email")
            password = request.POST.get("password")
            confirm_password = request.POST.get("confirm_password")

            if password != confirm_password:
                messages.error(request, "Passwords do not match.")
                return redirect("register")

            try:
                response = requests.post(
                    f"{settings.API_HOST}/users/register",
                    json={"username": username, "email": email, "password": password},
                    timeout=5
                )

                if response.status_code == 200:
                    messages.success(request, "Registration successful! Please log in.")
                    return redirect("login")
                else:
                    error_detail = response.json().get("detail", "Registration failed.")
                    logger.warning(f"Registration failed for user '{username}': {error_detail}")
                    messages.error(request, error_detail)
                    return redirect("register")
            except requests.RequestException as e:
                logger.exception("Error during registration: %s", str(e))
                messages.error(request, f"Unable to connect to the server: {str(e)}")
                return redirect("register")

        return render(request, "register.html")

    @staticmethod
    @login_required
    def secure_view(request):
        """
        Secure view to fetch sensitive data from FastAPI.
        """
        headers = get_authorization_header(request)
        if not headers:
            messages.error(request, "You need to log in to access this page.")
            return redirect("login")

        try:
            response = requests.get(f"{settings.API_HOST}/secure-data", headers=headers, timeout=10)

            if response.status_code == 200:
                data = response.json()
                return render(request, "secure_view.html", {"data": data})
            elif response.status_code == 401:
                messages.error(request, "Session expired. Please log in again.")
                request.session.flush()  # Clear session
                return redirect("login")
            else:
                logger.error(f"Unexpected status code {response.status_code} from secure-data endpoint.")
                messages.error(request, "An error occurred while accessing secure data.")
                return redirect("login")
        except requests.RequestException as e:
            logger.exception("Error fetching secure data: %s", str(e))
            messages.error(request, "Unable to connect to the server.")
            return redirect("login")
