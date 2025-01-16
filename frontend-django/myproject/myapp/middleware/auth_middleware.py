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

        # Debug: Print the access token and role for logging
        print(f"Access Token: {access_token}, Role: {role}, Path: {request.path}")

        if not access_token and request.path not in allowed_paths:
            # Redirect to login if the user is not authenticated
            return redirect("login")

        if role == "customer" and request.path not in allowed_paths + [
            reverse("sportartikelen"),
            reverse("sportartikeldetails", kwargs={"artcode": 1}),  # Example dynamic URL
        ]:
            # Redirect customers to the homepage if they access unauthorized pages
            return redirect("homePage")
        
        return self.get_response(request)
