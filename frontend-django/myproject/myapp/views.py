import requests
import json
from django.shortcuts import render

#todo create ini file for hostname

def homepage(request):
    return render(request, 'homepage.html')

def suppliers(request):
    try:
        response = requests.get('http://middleware-fastapi:8000/suppliers')
        suppliers = response.json()
        print(suppliers)
        if response.status_code == 404:
            # Order not found
            return render(request, 'error.html', {'error_message': 'Supplier not found'})
        else:
            return render(request, 'suppliers.html', {'suppliers': suppliers})
    except KeyError:
        return render(request, 'error.html', {'message': suppliers['error']})

def supplierdetail(request, suppliercode):
    try:
        # Fetch supplier details from FastAPI middleware
        response1 = requests.get(f'http://middleware-fastapi:8000/suppliers/{suppliercode}')
        response2 = requests.get(f"http://middleware-fastapi:8000/orders/{suppliercode}")

        # Handle supplier not found
        if response1.status_code == 404:
            return HttpResponseNotFound("Supplier not found.")  # Or render an error page
        elif response2.status_code == 404:
            return render(request, 'error.html', {'error_message': 'Orders for this supplier not found.'})

        # Handle other errors
        if response1.status_code != 200 or response2.status_code != 200:
            return render(request, 'error.html', {'error_message': 'Error retrieving supplier or order details.'})

        # Parse JSON responses
        convertData1 = response1.json()
        convertData2 = response2.json()  # Expected to be a list of orders

        # Merge data
        data_merge = {
            "supplier_code": convertData1.get('supplier_code'),
            "supplier_name": convertData1.get('supplier_name'),
            "address": convertData1.get('address'),
            "city": convertData1.get('city'),
            "orders": convertData2  # List of orders
        }

        # Render the template with merged data
        return render(request, 'supplierdetail.html', {'data_merge': data_merge})

    except requests.exceptions.RequestException as e:
        # Handle connection errors or timeouts
        return render(request, 'error.html', {'error_message': f'Error connecting to the server: {str(e)}'})

    except KeyError as e:
        # Handle unexpected JSON structure
        return render(request, 'error.html', {'error_message': f'Missing expected data: {str(e)}'})

    except Exception as e:
        # Generic error handling
        return render(request, 'error.html', {'error_message': f'An unexpected error occurred: {str(e)}'})



# def orders(request):
#     response = requests.get('http://middleware-fastapi:8000/orders')
#     order = response.json()
#     print(order) 
#     return render(request, 'orders.html', {'orders': order})

# def orderdetails(request, ordernr):
    
#     response = requests.get(f'http://middleware-fastapi:8000/orderdetails/{ordernr}')
#     orderdetails = response.json()
#     print(orderdetails) 
#     return render(request, 'orderdetails.html', {'orderdetails': orderdetails})

import requests
from django.shortcuts import render
from django.http import HttpResponseNotFound

def sportartikeldetails(request, artcode):
    """
    Fetch and display details of a specific sporting article based on its article code.
    """
    try:
        # Fetch article details from the middleware
        response = requests.get(f'http://middleware-fastapi:8000/sports_articles/{artcode}', timeout=5)
        
        if response.status_code == 404:
            return HttpResponseNotFound("Sporting article not found.")
        elif response.status_code != 200:
            return render(request, 'error.html', {'message': 'An error occurred while retrieving the article details.'})
        
        # Parse the response JSON
        sportsarticle_list = response.json()

        # Ensure the response is a list and extract the first item
        if isinstance(sportsarticle_list, list) and len(sportsarticle_list) > 0:
            sportsarticle = sportsarticle_list[0]
        else:
            return render(request, 'error.html', {'message': 'Invalid API response format.'})
        
        # Pass the article details to the template
        return render(request, 'sportsarticlesdetails.html', {'sportsarticle': sportsarticle})

    except requests.exceptions.RequestException as e:
        return render(request, 'error.html', {'message': f"Error connecting to the server: {str(e)}"})
    except Exception as e:
        return render(request, 'error.html', {'message': f"An unexpected error occurred: {str(e)}"})

def sportartikelen(request):
    """
    Fetch and display a list of all sporting articles.
    """
    try:
        # Fetch list of articles from the middleware
        response = requests.get(f"http://middleware-fastapi:8000/sports_articles/", timeout=5)
        if response.status_code != 200:
            return render(request, 'error.html', {'message': 'An error occurred while retrieving the articles list.'})
        
        # Parse the response JSON
        sportArtikelen = response.json()

        # Ensure the structure is valid (expecting a list of articles)
        if isinstance(sportArtikelen, list):
            return render(request, 'sports_articles.html', {'sports_articles': sportArtikelen})
        else:
            raise ValueError("Unexpected response structure.")

    except requests.exceptions.RequestException as e:
        # Handle network-related errors
        return render(request, 'error.html', {'message': f"Error connecting to the server: {str(e)}"})
    except ValueError as e:
        # Handle unexpected response structure
        return render(request, 'error.html', {'message': str(e)})
    except Exception as e:
        # Catch-all for other exceptions
        return render(request, 'error.html', {'message': f"An unexpected error occurred: {str(e)}"})

def orderdetailsArt(request, artcode):
    try:
        response = requests.get(f"http://middleware-fastapi:8000/orderdetailsArt/{artcode}")
        orderdetails = response.json()
        getOrderNr = orderdetails[0]['ordernr']
        response = requests.get(f'http://middleware-fastapi:8000/orderdetails/{getOrderNr}')
        orderdetails = response.json()
   
        return render(request, 'orderdetails.html', {'orderdetails': orderdetails})
    except KeyError:
        return render(request, 'error.html', {'message': orderdetails['error']})
    
def inventory(request):
    try:
        response = requests.get(f"http://middleware-fastapi:8000/inventory")
        inventoryDetails = response.json()
        return render(request, 'inventory.html', {'inventory': inventoryDetails})
    except KeyError:
        return render(request, 'error.html', {'message': inventoryDetails['error']})

def login_under_construction(request):
    return render(request, 'under_construction.html')