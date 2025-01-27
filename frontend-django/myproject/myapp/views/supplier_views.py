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

class SupplierViews:
    @staticmethod
    @login_required
    def suppliers(request):
        headers = get_authorization_header(request)
        if not headers:
            messages.error(request, "You need to log in to view this page.")
            return redirect("login")

        try:
            response = requests.get(f"{settings.API_HOST}/suppliers", headers=headers)
            suppliers = response.json()
            if response.status_code == 404:
                return render_error_page(request, "Supplier not found", 404)
            return render(request, "suppliers.html", {"suppliers": suppliers})
        except requests.RequestException as e:
            logger.exception("Error fetching suppliers: %s", str(e))
            return render_error_page(request, f"Error connecting to the server: {str(e)}")

    @staticmethod
    @login_required
    def supplierdetail(request, suppliercode):
        headers = get_authorization_header(request)
        if not headers:
            messages.error(request, "You need to log in to view this page.")
            return redirect("login")

        try:
            response1 = requests.get(f"{settings.API_HOST}/suppliers/{suppliercode}", headers=headers)
            response2 = requests.get(f"{settings.API_HOST}/orders/{suppliercode}", headers=headers)

            if response1.status_code == 404:
                return HttpResponseNotFound("Supplier not found.")
            elif response2.status_code == 404:
                return render_error_page(request, "Orders for this supplier not found.", 404)

            if response1.status_code != 200 or response2.status_code != 200:
                return render_error_page(request, "Error retrieving supplier or order details.")

            convertData1 = response1.json()
            convertData2 = response2.json()

            data_merge = {
                "supplier_code": convertData1.get("supplier_code"),
                "supplier_name": convertData1.get("supplier_name"),
                "address": convertData1.get("address"),
                "city": convertData1.get("city"),
                "orders": convertData2,
            }

            return render(request, "supplierdetail.html", {"data_merge": data_merge})
        except requests.RequestException as e:
            logger.exception("Error fetching supplier details: %s", str(e))
            return render_error_page(request, f"Error connecting to the server: {str(e)}")
        except Exception as e:
            logger.exception("Unexpected error: %s", str(e))
            return render_error_page(request, f"An unexpected error occurred: {str(e)}")