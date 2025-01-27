import requests
import json
import jwt
import logging
from myapp.utils import get_authorization_header, login_required
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import JsonResponse, HttpResponseNotFound
from django.conf import settings
from django.views.decorators.http import require_POST, require_http_methods
from django.contrib.auth import logout
from jwt.exceptions import ExpiredSignatureError, InvalidTokenError

from myapp.utils import login_required  # custom login_required decorator

logger = logging.getLogger(__name__)
class ArticleViews:
    @staticmethod
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

    @staticmethod
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

    @staticmethod
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

    @staticmethod
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

    @staticmethod
    @csrf_exempt
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

    @staticmethod
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

    @staticmethod
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