# myapp/middleware/auth_middleware.py

from django.shortcuts import redirect
from django.urls import reverse

class RoleBasedAuthenticationMiddleware:
    """
    Middleware to handle role-based access control.
    """
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        allowed_paths = [
            reverse("homePage"),
            reverse("login"),
            reverse("register"),
            reverse("logout"),
        ]

        # Get access token and role from the session
        access_token = request.session.get("access_token")
        role = request.session.get("role")
        
        # If not logged in and trying to access a restricted path, redirect to login
        if not access_token and request.path not in allowed_paths:
            return redirect("login")

        # Example role-based check
        if role == "customer":
            # Let them access home, login, logout, register, 'sportartikelen', etc.
            allowed_for_customer = allowed_paths + [
                reverse("sportartikelen")]
            
            if request.path.startswith("/cart/"):
                return self.get_response(request)
            
            if request.path not in allowed_for_customer:
                return redirect("homePage")
        
        # If role is admin or something else, you can put more conditions

        return self.get_response(request)
