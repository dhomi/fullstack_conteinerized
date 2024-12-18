from django.shortcuts import redirect
from django.urls import reverse

class AuthenticationMiddleware:
    """
    Middleware to restrict access to certain pages for unauthenticated users
    using a session-stored access token.
    """
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Paths that are accessible without authentication
        allowed_paths = [
            reverse("homePage"),
            reverse("login"),
            reverse("register"),
        ]

        # Check if access token exists in the session
        access_token = request.session.get("access_token")

        # Allow access to permitted paths, otherwise redirect to login
        if not access_token and request.path not in allowed_paths:
            return redirect("login")  # Redirect to the login page

        return self.get_response(request)
