import requests
import json
from django.shortcuts import render, redirect, get_object_or_404
from requests.exceptions import RequestException
from django.views.decorators.csrf import csrf_exempt
from .models import Order

#todo create ini file for hostname

def homepage(request):
    return render(request, 'homepage.html')

def orders(request):
    try:
        response = requests.get('http://middleware-fastapi:8000/orders')
        order = response.json()
        print(order) 
        if response.status_code == 404:
            # Order not found
            return render(request, 'error.html', {'error_message': 'Order not found. Please check the order number and try again.'})
        elif response.status_code != 200:
            # Some other error occurred
            return render(request, 'error.html', {'error_message': 'An error occurred while retrieving the order. Please try again later.'})
        else:
            return render(request, 'orders.html', {'orders': order})
    except KeyError:
        return render(request, 'error.html', {'message': KeyError})

def orderdetails(request, ordernr):
    try:
        response = requests.get(f'http://middleware-fastapi:8000/orderdetails/{ordernr}')
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
    try:
        response = requests.get(f"http://middleware-fastapi:8000/orderdetailsArt/{artcode}")
        orderdetails = response.json()
        getOrderNr = orderdetails[0]['ordernr']
        response = requests.get(f'http://middleware-fastapi:8000/orderdetails/{getOrderNr}')
        orderdetails = response.json()
        return render(request, 'orderdetails.html', {'orderdetails': orderdetails})
    except KeyError:
        return render(request, 'error.html', {'message': KeyError})

@csrf_exempt  # Temporarily using csrf_exempt for testing, but it's better to properly handle CSRF tokens in production.
def update_order(request, order_number):
    order = get_object_or_404(Order, order_number=order_number)
    if request.method == 'POST':
        # Assuming you have fields such as order_price, delivery_date, and status
        order.order_price = request.POST.get('order_price')
        order.delivery_date = request.POST.get('delivery_date')
        order.status = request.POST.get('status')
        order.save()
        return redirect('order_details', ordernr=order.order_number)

    return render(request, 'orderdetails.html', {'order': order})

def create_order(request):
    return render(request, 'create_order.html')

def track_orders(request):
    return render(request, 'track_orders.html')
    