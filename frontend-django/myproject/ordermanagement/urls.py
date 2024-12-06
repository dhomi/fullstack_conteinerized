# ordermanagement/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('orders/', views.orders, name='orders'),
    path('orders/<int:ordernr>/', views.orderdetails, name='order_details'),
    path('create/', views.create_order, name='create_order'),
    path('track/', views.track_orders, name='track_orders'),
    path('update_order/<int:order_number>/', views.update_order, name='update_order'),
    # Add more order management-related URLs here
]
