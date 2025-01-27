from functools import wraps
import logging
from django.shortcuts import render, redirect

logger = logging.getLogger(__name__)

def login_required(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        # print("Access token in session:", request.session.get("access_token"))
        if not request.session.get("access_token"):
            return redirect("login")
        return view_func(request, *args, **kwargs)
    return wrapper

def some_view(request):
    logger.debug("Debug message")
    logger.info("Info message")
    logger.error("Error message")

def get_authorization_header(request):
    token = request.session.get("access_token")
    if not token:
        return None
    return {"Authorization": f"Bearer {token}"}

def render_error_page(request, error_message, status_code=500):
    return render(request, "error.html", {"error_message": error_message}, status=status_code)
