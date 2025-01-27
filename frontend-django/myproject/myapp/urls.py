# # myapp/urls.py

# from django.urls import path
# from . import views

# urlpatterns = [
#     # Home Page
#     path('', views.homepage, name='homePage'),

#     # Authentication
#     path('login/', views.login_view, name='login'),
#     path('logout/', views.logout_view, name='logout'),
#     path('register/', views.register_view, name='register'),

#     # Suppliers
#     path('suppliers/', views.suppliers, name='suppliers'),
#     path('suppliers/<int:suppliercode>/', views.supplierdetail, name='supplierdetail'),

#     # Sporting Articles
#     path('sports_articles/', views.sportartikelen, name='sportartikelen'),
#     path('sports_articles/add/', views.add_sportartikel, name='add_sportartikel'),
#     path('sports_articles/update/<int:article_code>/', views.update_sportartikel, name='update_sportartikel'),
#     path('sports_articles/delete/<int:article_code>/', views.delete_sportartikel, name='delete_sportartikel'),
#     path('sports_articles/<int:artcode>/', views.sportartikeldetails, name='sportartikeldetails'),

#     # Inventory
#     path('inventory/', views.inventory, name='inventory'),

#     # Order Details
#     path('orderdetailsArt/<int:artcode>/', views.orderdetailsArt, name='orderdetailsArt'),
#     # path('orderdetails/<int:ordernr>/', views.orderdetails, name='orderdetails'),

#     # Cart
#     path('cart/', views.cart_view, name='cart'),
#     path('cart/add/<int:article_code>/', views.add_to_cart_view, name='add_to_cart'),
#     path('cart/update/', views.update_cart_view, name='update_cart'),
#     path('cart/delete/<int:article_code>/', views.remove_cart_view, name='remove_cart'),
#     path('cart/count/', views.cart_count_view, name='cart_count'),

#     # Secure View
#     path('secure/', views.secure_view, name='secure_view'),

#     # Under Construction
#     path('under_construction/', views.login_under_construction, name='under_construction'),
# ]

from django.urls import path
from .views.auth_views import AuthViews
from .views.supplier_views import SupplierViews
from .views.article_views import ArticleViews
from .views.cart_views import CartViews
from .views.core_views import CoreViews


urlpatterns = [
    path("", CoreViews.homepage, name="homePage"),
    path("under_construction/", CoreViews.login_under_construction, name="under_construction"),

    # Authentication
    path("login/", AuthViews.login_view, name="login"),
    path("logout/", AuthViews.logout_view, name="logout"),
    path("register/", AuthViews.register_view, name="register"),
    path("secure/", AuthViews.secure_view, name="secure_view"),

    # Supplier
    path("suppliers/", SupplierViews.suppliers, name="suppliers"),
    path("suppliers/<int:suppliercode>/", SupplierViews.supplierdetail, name="supplierdetail"),

    # Articles
    path("sports_articles/", ArticleViews.sportartikelen, name="sportartikelen"),
    path("sports_articles/<int:artcode>/", ArticleViews.sportartikeldetails, name="sportartikeldetails"),
    path("sports_articles/add/", ArticleViews.add_sportartikel, name="add_sportartikel"),
    path("sports_articles/update/<int:article_code>/", ArticleViews.update_sportartikel, name="update_sportartikel"),
    path("sports_articles/delete/<int:article_code>/", ArticleViews.delete_sportartikel, name="delete_sportartikel"),
    path("inventory/", ArticleViews.inventory, name="inventory"),
    path("orderdetailsArt/<int:artcode>/", ArticleViews.orderdetailsArt, name="orderdetailsArt"),

    # Cart
    path("cart/", CartViews.cart_view, name="cart"),
    path("cart/add/<int:article_code>/", CartViews.add_to_cart_view, name="add_to_cart"),
    path("cart/update/", CartViews.update_cart_view, name="update_cart"),
    path("cart/delete/<int:article_code>/", CartViews.remove_cart_view, name="remove_cart"),
    path("cart/count/", CartViews.cart_count_view, name="cart_count"),
]
