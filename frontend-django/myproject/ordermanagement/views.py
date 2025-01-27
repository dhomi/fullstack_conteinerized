import requests
import json
from django.conf import settings
from django.http import JsonResponse 
from django.shortcuts import render, redirect, get_object_or_404
from requests.exceptions import RequestException
from django.views.decorators.csrf import csrf_protect
from .models import Order

#todo create ini file for hostname

def homepage(request):
    return render(request, 'homepage.html')

def orders(request):
    """
    Fetch and display orders.
    """
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}

    try:
        # Fetch orders from the middleware
        response = requests.get(f"{settings.API_HOST}/orders", headers=headers, timeout=5)

        if response.status_code == 401:
            messages.error(request, "Unauthorized access. Please log in again.")
            return redirect("login")

        if response.status_code != 200:
            return render(request, 'error.html', {'message': 'An error occurred while retrieving orders.'})

        # Parse the orders data
        orders = response.json()
        return render(request, 'orders.html', {'orders': orders})

    except requests.exceptions.RequestException as e:
        return render(request, 'error.html', {'message': f"Error connecting to the server: {str(e)}"})

def orderdetails(request, ordernr):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(f'{settings.API_HOST}/orderdetails/{ordernr}', headers=headers, timeout=5)
        if response.status_code == 404:
            # Order not found
            return render(request, 'error.html', {'error_message': 'Order not found. Please check the order number and try again.'})
        elif response.status_code != 200:
            # Some other error occurred
            return render(request, 'error.html', {'error_message': 'An error occurred while retrieving the order. Please try again later.'})

        orderdetails = response.json()
        print(orderdetails) 
        return render(request, 'orderdetails.html', {'orderdetails': orderdetails})
    except KeyError:
        return render(request, 'error.html', {'message': KeyError})
    except RequestException as e:
        return render(request, 'error.html', {'error_message': f'Unable to connect to the order management system. Error: {str(e)}'})

def orderdetailsArt(request, artcode):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(f"{settings.API_HOST}/orderdetailsArt/{artcode}", headers=headers, timeout=5)
        orderdetails = response.json()
        getOrderNr = orderdetails[0]['ordernr']
        response = requests.get(f"{settings.API_HOST}/orderdetails/{getOrderNr}", headers=headers, timeout=5)
        orderdetails = response.json()
        return render(request, 'orderdetails.html', {'orderdetails': orderdetails})
    except KeyError:
        return render(request, 'error.html', {'message': KeyError})

@csrf_protect  # Temporarily using csrf_exempt for testing, but it's better to properly handle CSRF tokens in production.
def update_order_view(request, orderNumber):
    if request.method == "PUT":
        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"error": "You must be logged in."}, status=401)

        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON."}, status=400)

        # data now includes: supplier_code, order_number, article_code, order_price, ...
        # Make your PUT to FastAPI:
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

        url = f"{settings.API_HOST}/orders/{orderNumber}"
        # or if your FastAPI endpoint is something else
        # e.g., "http://localhost:8000/orders/<ordernr>"

        # Example body for FastAPI:
        # You might tailor it to match the FastAPI order schema
        fastapi_payload = {
            "supplier_code": data["supplier_code"],
            "article_code": data["article_code"],
            "order_price": data["order_price"],
            "order_date": data["order_date"],
            "delivery_date": data["delivery_date"],
            "status": data["status"]
        }

        resp = requests.put(url, headers=headers, json=fastapi_payload)

        if resp.status_code == 200:
            return JsonResponse({"message": "Order updated successfully in FastAPI."})
        else:
            return JsonResponse({
                "error": "Failed to update in FastAPI.",
                "details": resp.text
            }, status=resp.status_code)

    return JsonResponse({"error": "Method not allowed."}, status=405)

def create_order(request):
    return render(request, 'create_order.html')

def track_orders(request):
    return render(request, 'track_orders.html')
    