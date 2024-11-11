from django.urls import path 
from django.views.generic import RedirectView
from django.contrib.staticfiles.storage import staticfiles_storage
from . import views

urlpatterns = [
    path('', views.homepage, name='homePage'),
    path('suppliers/', views.suppliers, name='suppliers'),
    path('suppliers/<int:suppliercode>/', views.supplierdetail, name='supplierdetail'),
    path('orders/', views.orders, name='orders'),
    path('orders/<int:ordernr>/', views.orderdetails, name='orderdetails'),
    path('orderdetailsArt/<int:artcode>/', views.orderdetailsArt, name='orderdetails'),
    path('sportartikelen/', views.sportartikelen, name='sportartikelen'),
    path('sportartikelen/<int:artcode>/', views.sportartikeldetails, name='sportartikeldetails'),
    path('favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('favicon/favicon.ico'))),
]