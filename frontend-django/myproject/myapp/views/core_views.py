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

class CoreViews:
    """
    Core or miscellaneous views like homepage or 'under_construction'.
    """
    @staticmethod
    def homepage(request):
        return render(request, 'homepage.html')

    @staticmethod
    def login_under_construction(request):
        return render(request, 'under_construction.html')