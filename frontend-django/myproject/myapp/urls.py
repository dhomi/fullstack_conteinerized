# myapp/urls.py

from django.urls import path
from . import views

urlpatterns = [
    # Home Page
    path('', views.homepage, name='homePage'),

    # Authentication
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('register/', views.register_view, name='register'),

    # Suppliers
    path('suppliers/', views.suppliers, name='suppliers'),
    path('suppliers/<int:suppliercode>/', views.supplierdetail, name='supplierdetail'),

    # Sporting Articles
    path('sports_articles/', views.sportartikelen, name='sportartikelen'),
    path('sports_articles/add/', views.add_sportartikel, name='add_sportartikel'),
    path('sports_articles/update/<int:article_code>/', views.update_sportartikel, name='update_sportartikel'),
    path('sports_articles/delete/<int:article_code>/', views.delete_sportartikel, name='delete_sportartikel'),
    path('sports_articles/<int:artcode>/', views.sportartikeldetails, name='sportartikeldetails'),

    # Inventory
    path('inventory/', views.inventory, name='inventory'),

    # Order Details
    path('orderdetailsArt/<int:artcode>/', views.orderdetailsArt, name='orderdetailsArt'),
    # path('orderdetails/<int:ordernr>/', views.orderdetails, name='orderdetails'),

    # Cart
    path('cart/', views.cart_view, name='cart'),
    path('cart/add/<int:article_code>/', views.add_to_cart_view, name='add_to_cart'),
    path('cart/update/', views.update_cart_view, name='update_cart'),
    path('cart/delete/<int:article_code>/', views.remove_cart_view, name='remove_cart'),
    path('cart/count/', views.cart_count_view, name='cart_count'),

    # Secure View
    path('secure/', views.secure_view, name='secure_view'),

    # Under Construction
    path('under_construction/', views.login_under_construction, name='under_construction'),
]
