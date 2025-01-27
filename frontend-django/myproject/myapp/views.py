import requests
import json
import jwt
import logging
from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import JsonResponse, HttpResponseNotFound
from django.conf import settings
from django.views.decorators.http import require_POST, require_http_methods
from django.contrib.auth import logout
from jwt.exceptions import ExpiredSignatureError, InvalidTokenError
from .utils import login_required  # Assuming you have a custom login_required decorator

logger = logging.getLogger(__name__)

def some_view(request):
    logger.debug("Debug message")
    logger.info("Info message")
    logger.error("Error message")

# Utility to fetch Authorization header
def get_authorization_header(request):
    token = request.session.get("access_token")
    if not token:
        return None
    return {"Authorization": f"Bearer {token}"}

# Utility to render consistent error pages
def render_error_page(request, error_message, status_code=500):
    return render(request, "error.html", {"error_message": error_message}, status=status_code)

def homepage(request):
    return render(request, 'homepage.html')

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

@login_required
def sportartikeldetails(request, artcode):
    headers = get_authorization_header(request)
    if not headers:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    try:
        response = requests.get(f"{settings.API_HOST}/sports_articles/{artcode}", headers=headers, timeout=5)
        if response.status_code == 404:
            return HttpResponseNotFound("Sporting article not found.")
        elif response.status_code != 200:
            return render_error_page(request, "An error occurred while retrieving the article details.")

        sportsarticle_list = response.json()
        if isinstance(sportsarticle_list, list) and sportsarticle_list:
            sportsarticle = sportsarticle_list[0]
        else:
            return render_error_page(request, "Invalid API response format.")

        return render(request, "sportsarticlesdetails.html", {"sportsarticle": sportsarticle})
    except requests.RequestException as e:
        logger.exception("Error fetching sporting article details: %s", str(e))
        return render_error_page(request, f"Error connecting to the server: {str(e)}")
    except Exception as e:
        logger.exception("Unexpected error: %s", str(e))
        return render_error_page(request, f"An unexpected error occurred: {str(e)}")

@login_required
def sportartikelen(request):
    headers = get_authorization_header(request)
    if not headers:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    try:
        response = requests.get(f"{settings.API_HOST}/sports_articles/", headers=headers, timeout=5)
        if response.status_code != 200:
            return render_error_page(request, "An error occurred while retrieving the articles list.")

        sportArtikelen = response.json()
        if isinstance(sportArtikelen, list):
            return render(request, "sports_articles.html", {"sports_articles": sportArtikelen})
        else:
            raise ValueError("Unexpected response structure.")
    except requests.RequestException as e:
        return render_error_page(request, f"Error connecting to the server: {str(e)}")
    except ValueError as e:
        return render_error_page(request, str(e))
    except Exception as e:
        return render_error_page(request, f"An unexpected error occurred: {str(e)}")

def delete_sportartikel(request, article_code):
    """
    Receives DELETE (or POST) from the front end,
    calls FastAPI to remove the article.
    """
    if request.method == "DELETE":
        token = request.session.get("access_token")
        if not token:
            return JsonResponse({"error": "Not authenticated"}, status=401)

        headers = {"Authorization": f"Bearer {token}"}
        url = f"{settings.API_HOST}/sports_articles/{article_code}"
        resp = requests.delete(url, headers=headers)

        if resp.status_code in (200, 204):
            return JsonResponse({"message": "Article deleted successfully!"})
        else:
            return JsonResponse({"error": resp.text}, status=resp.status_code)

    return JsonResponse({"error": "Method not allowed"}, status=405)

@login_required
def add_sportartikel(request):
    if request.method == "POST":
        token = request.session.get("access_token")
        if not token:
            messages.error(request, "You need to log in to perform this action.")
            return redirect("login")

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
            api_url = f"{settings.API_HOST}/sports_articles/"
            response = requests.post(api_url, headers=headers, json=article_data, timeout=5)

            if response.status_code == 200:
                messages.success(request, "Sport article added successfully.")
                return redirect("sportartikelen")
            elif response.status_code == 400:
                error_detail = response.json().get("detail", "Invalid data provided.")
                messages.error(request, f"Failed to add article: {error_detail}")
            else:
                messages.error(request, "An unexpected error occurred while adding the article.")
        except requests.RequestException as e:
            messages.error(request, f"Error connecting to the server: {str(e)}")

        return redirect("add_sportartikel")

    return render(request, "add_sportsarticle.html")

@login_required
@require_http_methods(["PUT"])
def update_sportartikel(request, article_code):
    """
    Django view to update a sport article's details via AJAX.
    Expects JSON body with fields to update.
    """
    token = request.session.get("access_token")
    if not token:
        return JsonResponse({"detail": "You need to log in first!"}, status=401)

    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({"detail": "Invalid JSON data"}, status=400)

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    api_url = f"{settings.API_HOST}/sports_articles/{article_code}"

    try:
        response = requests.put(api_url, headers=headers, json=data, timeout=5)
    except requests.RequestException as e:
        return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

    if response.status_code == 200:
        return JsonResponse({"message": "Sport article updated successfully!"}, status=200)
    else:
        try:
            error_detail = response.json().get("detail", "Failed to update sport article.")
        except json.JSONDecodeError:
            error_detail = "Failed to update sport article."
        return JsonResponse({"detail": error_detail}, status=response.status_code)

@login_required
def inventory(request):
    token = request.session.get("access_token")
    if not token:
        print("Access token not found in session.")
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{settings.API_HOST}/inventory", headers=headers)
        print(f"inventory response = {response} | header = {headers}")
        if response.status_code == 401:
            print("Token is invalid or expired.")
            messages.error(request, "Session expired. Please log in again.")
            return redirect("login")
        inventoryDetails = response.json()
        return render(request, 'inventory.html', {'inventory': inventoryDetails})
    except Exception as e:
        print(f"Error fetching inventory: {e}")
        messages.error(request, f"Error: {str(e)}")
        return redirect("login")

def login_under_construction(request):
    return render(request, 'under_construction.html')

def login_view(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        try:
            response = requests.post(
                f"{settings.API_HOST}/users/login",
                data={"username": username, "password": password},
                timeout=5
            )
            if response.status_code == 200:
                data = response.json()
                access_token = data.get("access_token")
                if access_token:
                    user_info = data.get("user", {})
                    user_role = user_info.get("role", None)
                    user_name = user_info.get("username", None)
                    
                    try:
                        decoded = jwt.decode(access_token, settings.SECRET_KEY, algorithms=["HS256"])
                        role = decoded.get("role")
                        if role:
                            request.session['role'] = role
                        else:
                            messages.error(request, "Invalid token: Missing role.")
                            return redirect("login")
                    except jwt.ExpiredSignatureError:
                        messages.error(request, "Token has expired.")
                        return redirect("login")
                    except jwt.InvalidTokenError:
                        messages.error(request, "Invalid token.")
                        return redirect("login")
                    except (ExpiredSignatureError, InvalidTokenError) as e:
                        messages.error(request, "Invalid or expired token.")
                        return redirect("login")

                    # Store to session
                    request.session["access_token"] = access_token
                    request.session["role"] = user_role  
                    request.session["username"] = user_name  
                    
                    return redirect("homePage")
                else:
                    messages.error(request, "No access token returned by server.")
                    return redirect("login")
            else:
                messages.error(request, "Invalid credentials.")
                return redirect("login")
        except requests.RequestException as e:
            messages.error(request, f"Login error: {e}")
            return redirect("login")
    else:
        return render(request, "login.html")

@login_required
def secure_view(request):
    """
    Secure view to fetch sensitive data from FastAPI.
    """
    headers = get_authorization_header(request)
    if not headers:
        messages.error(request, "You need to log in to access this page.")
        return redirect("login")

    try:
        response = requests.get(f"{settings.API_HOST}/secure-data", headers=headers, timeout=10)

        if response.status_code == 200:
            data = response.json()
            return render(request, "secure_view.html", {"data": data})
        elif response.status_code == 401:
            messages.error(request, "Session expired. Please log in again.")
            request.session.flush()  # Clear session
            return redirect("login")
        else:
            logger.error(f"Unexpected status code {response.status_code} from secure-data endpoint.")
            messages.error(request, "An error occurred while accessing secure data.")
            return redirect("login")
    except requests.RequestException as e:
        logger.exception("Error fetching secure data: %s", str(e))
        messages.error(request, "Unable to connect to the server.")
        return redirect("login")

def logout_view(request):
    """
    Logout view to clear session and redirect to login page.
    """
    request.session.flush()
    messages.success(request, "You have been successfully logged out.")
    return redirect("login")

def register_view(request):
    """
    User registration view.
    """
    if request.method == "POST":
        username = request.POST.get("username")
        email = request.POST.get("email")
        password = request.POST.get("password")
        confirm_password = request.POST.get("confirm_password")

        if password != confirm_password:
            messages.error(request, "Passwords do not match.")
            return redirect("register")

        try:
            response = requests.post(
                f"{settings.API_HOST}/users/register",
                json={"username": username, "email": email, "password": password},
                timeout=5
            )

            if response.status_code == 200:
                messages.success(request, "Registration successful! Please log in.")
                return redirect("login")
            else:
                error_detail = response.json().get("detail", "Registration failed.")
                logger.warning(f"Registration failed for user '{username}': {error_detail}")
                messages.error(request, error_detail)
                return redirect("register")
        except requests.RequestException as e:
            logger.exception("Error during registration: %s", str(e))
            messages.error(request, f"Unable to connect to the server: {str(e)}")
            return redirect("register")

    return render(request, "register.html")

@login_required
def orderdetailsArt(request, artcode):
    """
    Fetch and display order details for a given article code.
    """
    headers = get_authorization_header(request)
    if not headers:
        messages.error(request, "You need to log in to view this page.")
        return redirect("login")

    try:
        response1 = requests.get(f"{settings.API_HOST}/orderdetailsArt/{artcode}", headers=headers)
        if response1.status_code == 404:
            return HttpResponseNotFound("Order details for this article not found.")
        elif response1.status_code != 200:
            return render_error_page(request, "Error fetching order details for the article.")

        orderdetails_art = response1.json()

        if not isinstance(orderdetails_art, list) or not orderdetails_art:
            return render_error_page(request, "Invalid response structure for article order details.")

        getOrderNr = orderdetails_art[0].get("ordernr")
        if not getOrderNr:
            return render_error_page(request, "Order number missing in the response.")

        response2 = requests.get(f"{settings.API_HOST}/orderdetails/{getOrderNr}", headers=headers)
        if response2.status_code == 404:
            return HttpResponseNotFound("Order details not found.")
        elif response2.status_code != 200:
            return render_error_page(request, "Error fetching detailed order information.")

        orderdetails = response2.json()
        return render(request, "orderdetails.html", {"orderdetails": orderdetails})
    except requests.RequestException as e:
        logger.exception("Error fetching order details: %s", str(e))
        return render_error_page(request, f"Error connecting to the server: {str(e)}")
    except Exception as e:
        logger.exception("Unexpected error: %s", str(e))
        return render_error_page(request, f"An unexpected error occurred: {str(e)}")

# ------------------------------
# Cart Views
# ------------------------------

@login_required
@require_POST
def add_to_cart_view(request, article_code):
    """
    Django view to handle adding an article to the cart via AJAX or form submission.
    """
    token = request.session.get("access_token")
    if not token:
        return JsonResponse({"detail": "You need to log in first!"}, status=401)

    # Determine if the request is AJAX or form submission based on content type
    if request.headers.get('Content-Type') == 'application/json':
        # AJAX request
        try:
            data = json.loads(request.body)
            quantity = data.get("quantity", 1)
        except json.JSONDecodeError:
            quantity = 1
    else:
        # Form submission
        quantity = request.POST.get("quantity", 1)

    try:
        quantity = int(quantity)
        if quantity < 1:
            raise ValueError
    except ValueError:
        return JsonResponse({"detail": "Invalid quantity specified."}, status=400)

    try:
        response = requests.post(
            f"{settings.API_HOST}/cart/add/",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            json={
                "article_code": article_code,
                "quantity": quantity
            },
            timeout=5
        )
    except requests.RequestException as e:
        logger.exception("Error connecting to FastAPI: %s", str(e))
        return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

    if response.status_code == 200:
        if request.headers.get('Content-Type') == 'application/json':
            return JsonResponse({"message": "Item added to cart successfully!"}, status=200)
        else:
            messages.success(request, "Item added to cart successfully!")
            return redirect("sportartikelen")
    else:
        try:
            error_detail = response.json().get("detail", "Failed to add to cart.")
        except json.JSONDecodeError:
            error_detail = "Failed to add to cart."
        if request.headers.get('Content-Type') == 'application/json':
            return JsonResponse({"detail": error_detail}, status=response.status_code)
        else:
            messages.error(request, f"Error: {error_detail}")
            return redirect("sportartikelen")

@require_http_methods(["PUT"])
def update_cart_view(request):
    """
    Django view to update the quantity of a cart item via AJAX.
    Expects JSON body with 'article_code' and 'quantity'.
    """
    try:
        data = json.loads(request.body)
        article_code = data.get("article_code")
        quantity = data.get("quantity")

        if not article_code or not isinstance(quantity, int) or quantity < 1:
            return JsonResponse({"detail": "Invalid request data."}, status=400)
    except json.JSONDecodeError:
        return JsonResponse({"detail": "Invalid JSON."}, status=400)

    token = request.session.get("access_token")
    if not token:
        return JsonResponse({"detail": "You need to log in first!"}, status=401)

    try:
        response = requests.put(
            f"{settings.API_HOST}/cart/update/",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            json={
                "article_code": article_code,
                "quantity": quantity
            },
            timeout=5
        )
    except requests.RequestException as e:
        logger.exception("Error connecting to FastAPI: %s", str(e))
        return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

    if response.status_code == 200:
        data = response.json()
        return JsonResponse({"message": "Cart item updated successfully!", "cart_count": data.get("cart_count", 0)}, status=200)
    else:
        try:
            error_detail = response.json().get("detail", "Failed to update cart item.")
        except json.JSONDecodeError:
            error_detail = "Failed to update cart item."
        return JsonResponse({"detail": error_detail}, status=response.status_code)

@require_http_methods(["DELETE"])
def remove_cart_view(request, article_code):
    """
    Django view to remove an article from the cart via AJAX.
    """
    token = request.session.get("access_token")
    if not token:
        return JsonResponse({"detail": "You need to log in first!"}, status=401)

    try:
        response = requests.delete(
            f"{settings.API_HOST}/cart/delete/{article_code}",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            timeout=5
        )
    except requests.RequestException as e:
        logger.exception("Error connecting to FastAPI: %s", str(e))
        return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

    if response.status_code == 200:
        return JsonResponse({"message": "Cart item removed successfully!"}, status=200)
    else:
        try:
            error_detail = response.json().get("detail", "Failed to remove cart item.")
        except json.JSONDecodeError:
            error_detail = "Failed to remove cart item."
        return JsonResponse({"detail": error_detail}, status=response.status_code)

@login_required
def cart_view(request):
    """
    Django view to display the user's cart.
    Fetches cart items from FastAPI.
    """
    token = request.session.get("access_token")
    if not token:
        messages.error(request, "You need to log in to view your cart.")
        return redirect("login")

    try:
        response = requests.get(
            f"{settings.API_HOST}/cart/",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            timeout=5
        )
    except requests.RequestException as e:
        logger.exception("Error connecting to FastAPI: %s", str(e))
        messages.error(request, f"Error connecting to the server: {e}")
        return redirect("homePage")

    if response.status_code == 200:
        data = response.json()
        return render(request, "cart.html", {"cart": data})
    else:
        try:
            error_detail = response.json().get("detail", "Failed to retrieve cart.")
        except json.JSONDecodeError:
            error_detail = "Failed to retrieve cart."
        messages.error(request, f"Error: {error_detail}")
        return redirect("homePage")

@login_required
@require_http_methods(["GET"])
def cart_count_view(request):
    """
    Django view to retrieve the current number of items in the user's cart.
    Returns a JSON response with the cart count.
    """
    token = request.session.get("access_token")
    if not token:
        return JsonResponse({"detail": "You need to log in first!"}, status=401)

    try:
        response = requests.get(
            f"{settings.API_HOST}/cart/count/",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            timeout=5
        )
    except requests.RequestException as e:
        logger.exception("Error connecting to FastAPI: %s", str(e))
        return JsonResponse({"detail": f"Error connecting to the server: {e}"}, status=500)

    if response.status_code == 200:
        data = response.json()
        cart_count = data.get("cart_count", 0)
        return JsonResponse({"cart_count": cart_count}, status=200)
    else:
        logger.error("Failed to retrieve cart count. Status code: %s", response.status_code)
        return JsonResponse({"cart_count": 0}, status=200)