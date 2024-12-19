from django.urls import path, include
from django.views.generic import RedirectView
from django.contrib.staticfiles.storage import staticfiles_storage
from . import views

urlpatterns = [
    path('', views.homepage, name='homePage'),
    path('suppliers/', views.suppliers, name='suppliers'),
    path('suppliers/<int:suppliercode>/', views.supplierdetail, name='supplierdetail'),
    # path('/ordermanagement/orders/', views.orders, name='orders'),
    # path('/ordermanagement/orders/<int:ordernr>/', views.orderdetails, name='orderdetails'),
    path('orderdetailsArt/<int:artcode>/', views.orderdetailsArt, name='orderdetails'),
    path('sports_articles/', views.sportartikelen, name='sportartikelen'),
    path('sports_articles/<int:artcode>/', views.sportartikeldetails, name='sportartikeldetails'),
    path('inventory/', views.inventory, name='inventory'),
    path('ordermanagement/', include('ordermanagement.urls')),
    path('favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('favicon/favicon.ico'))),
    path('sports_articles/add', views.login_under_construction, name='login'),
    path("login/", views.login_view, name="login"),
    path("logout/", views.logout_view, name="logout"),
    path("secure-page/", views.secure_view, name="secure_page"),
    path("register/", views.register_view, name="register"),
    # path('', views.home_page, name='homePage'), 
]
