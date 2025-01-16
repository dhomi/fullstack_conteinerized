import requests
import json
import jwt
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.messages import get_messages
from django.contrib.auth import logout
from django.conf import settings
from django.http import HttpResponseNotFound
from jwt.exceptions import ExpiredSignatureError, InvalidTokenError
from .utils import login_required 


#todo create ini file for hostname

def homepage(request):
    return render(request, 'homepage.html')

@login_required
def suppliers(request):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get('http://middleware-fastapi:8000/suppliers', headers=headers)
        suppliers = response.json()
        print(suppliers)
        if response.status_code == 404:
            # Order not found
            return render(request, 'error.html', {'error_message': 'Supplier not found'})
        else:
            return render(request, 'suppliers.html', {'suppliers': suppliers})
    except KeyError:
        return render(request, 'error.html', {'message': suppliers['error']})

@login_required
def supplierdetail(request, suppliercode):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        # Fetch supplier details from FastAPI middleware
        response1 = requests.get(f"http://middleware-fastapi:8000/suppliers/{suppliercode}", headers=headers)
        response2 = requests.get(f"http://middleware-fastapi:8000/orders/{suppliercode}", headers=headers)

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

@login_required
def sportartikeldetails(request, artcode):
    """
    Fetch and display details of a specific sporting article based on its article code.
    """
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        # Fetch article details from the middleware
        response = requests.get(f'http://middleware-fastapi:8000/sports_articles/{artcode}', headers=headers,timeout=5)
        
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

@login_required
def sportartikelen(request):
    """
    Fetch and display a list of all sporting articles.
    """
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        # Fetch list of articles from the middleware
        response = requests.get(f"http://middleware-fastapi:8000/sports_articles/", headers=headers,timeout=5)
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

@login_required
def add_sportartikel(request):
    """
    Handle adding a new sporting article.
    """
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to perform this action.")
        return redirect("login")

    if request.method == "POST":
        # Gather data from the POST request
        article_data = {
            "article_name": request.POST.get("article_name"),
            "category": request.POST.get("category"),
            "size": request.POST.get("size"),
            "color": request.POST.get("color"),
            "price": request.POST.get("price"),
            "stock_quantity": request.POST.get("stock_quantity"),
            "stock_min": request.POST.get("stock_min"),
            "vat_type": request.POST.get("vat_type"),
        }

        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

        try:
            # Send POST request to middleware to add the article
            response = requests.post(
                f"http://middleware-fastapi:8000/sports_articles/",
                headers=headers,
                json=article_data,
                timeout=5
            )

            if response.status_code == 201:
                messages.success(request, "Sport article added successfully.")
                return redirect("sportartikelen")  # Redirect to the list of articles
            elif response.status_code == 400:
                error_message = response.json().get("detail", "Invalid data provided.")
                messages.error(request, f"Failed to add article: {error_message}")
            else:
                messages.error(request, "An unexpected error occurred while adding the article.")
        except requests.exceptions.RequestException as e:
            # Handle network-related errors
            messages.error(request, f"Error connecting to the server: {str(e)}")
        except Exception as e:
            # Generic error handling
            messages.error(request, f"An unexpected error occurred: {str(e)}")

    # Render the form page
    return render(request, "add_sportsarticle.html")


@login_required
def orderdetailsArt(request, artcode):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(f"http://middleware-fastapi:8000/orderdetailsArt/{artcode}", headers=headers)
        orderdetails = response.json()
        getOrderNr = orderdetails[0]['ordernr']
        response = requests.get(f"http://middleware-fastapi:8000/orderdetails/{getOrderNr}", headers=headers)
        orderdetails = response.json()
   
        return render(request, 'orderdetails.html', {'orderdetails': orderdetails})
    except KeyError:
        return render(request, 'error.html', {'message': orderdetails['error']})

@login_required
def inventory(request):
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    print(request.session.get("access_token"))
    try:
        response = requests.get(f"http://middleware-fastapi:8000/inventory", headers=headers)
        inventoryDetails = response.json()
        return render(request, 'inventory.html', {'inventory': inventoryDetails})
    except KeyError:
        return render(request, 'error.html', {'message': inventoryDetails['error']})

def login_under_construction(request):
    return render(request, 'under_construction.html')

def login_view(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        response = requests.post(
            f"http://middleware-fastapi:8000/users/login",
            data={"username": username, "password": password},
        )

        if response.status_code == 200:
            token_data = response.json()
            access_token = token_data["access_token"]
            print(f"Access Token Received: {access_token}")  # Debug

            try:
                decoded_token = jwt.decode(
                    access_token,
                    settings.SECRET_KEY,
                    algorithms=["HS256"],
                )
                print(f"Decoded Token: {decoded_token}")  # Debug

                request.session["access_token"] = access_token
                request.session["username"] = decoded_token.get("sub")
                request.session["role"] = decoded_token.get("role")
                messages.success(request, "Login successful!")
                return redirect("/")
            except jwt.ExpiredSignatureError:
                messages.error(request, "Token has expired. Please log in again.")
                return redirect("login")
            except jwt.InvalidTokenError:
                messages.error(request, "Invalid token. Please log in again.")
                return redirect("login")
        else:
            messages.error(request, "Invalid username or password")
            return redirect("login")

    return render(request, "login.html")


@login_required
def secure_view(request):
    token = request.session.get("access_token")
    print("Secure view token:", token)  # Debugging print statement

    if not token:
        return redirect("login")  # This should not trigger if the token exists

    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(
            "http://middleware-fastapi:8000/secure-data", headers=headers, timeout=10
        )
        if response.status_code == 200:
            data = response.json()
            return render(request, "secure_view.html", {"data": data})
        elif response.status_code == 401:
            messages.error(request, "Session expired. Please log in again.")
            del request.session["access_token"]
            return redirect("login")
        else:
            messages.error(request, "An error occurred.")
            return redirect("login")
    except requests.exceptions.RequestException as e:
        messages.error(request, "Unable to connect to the server.")
        return redirect("login")

def logout_view(request):
    # Clear the session data
    request.session.flush()
    messages.success(request, "You have been successfully logged out.")
    return redirect("login")  # Redirect to the login page


def register_view(request):
    if request.method == "POST":
        username = request.POST.get("username")
        email = request.POST.get("email")
        password = request.POST.get("password")
        confirm_password = request.POST.get("confirm_password")

        if password != confirm_password:
            messages.error(request, "Passwords do not match")
            return redirect("register")

        response = requests.post(
            "http://middleware-fastapi:8000/users/register",
            json={"username": username, "email": email, "password": password},
        )

        if response.status_code == 200:
            messages.success(request, "Registration successful! Please login.")
            return redirect("login")
        else:
            messages.error(request, response.json().get("detail", "Registration failed"))
            return redirect("register")

    return render(request, "register.html")

# def home_page(request):
#     if request.session.get("access_token"):
#         return render(request, "homepage_logged_in.html")
#     return render(request, "homepage.html")