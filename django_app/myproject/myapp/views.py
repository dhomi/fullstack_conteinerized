import requests
import json
from django.shortcuts import render

def homepage(request):
    return render(request, 'homepage.html')

def suppliers(request):
    response = requests.get('http://fastapi_app:8000/suppliers')
    suppliers = response.json()
    print(suppliers)  
    return render(request, 'suppliers.html', {'suppliers': suppliers})

def supplierdetail(request, suppliercode):
    response1 = requests.get(f'http://fastapi_app:8000/suppliers/{suppliercode}')
    convertData1 = response1.json()
    response2 = requests.get(f"http://fastapi_app:8000/orders/{suppliercode}")
    convertData2 = response2.json()
    data_merge = {"suppliercode":convertData1['suppliercode'], "ordernr":convertData2['ordernr'], "suppliername":convertData1['suppliername'], "address":convertData1['address'], "residence":convertData1['residence']}
    print(data_merge['suppliercode'])
    return render(request, 'supplierdetail.html', {'data_merge': data_merge})

def orders(request):
    response = requests.get('http://fastapi_app:8000/orders')
    order = response.json()
    print(order) 
    return render(request, 'orders.html', {'orders': order})

def orderdetails(request, ordernr):
    
    response = requests.get(f'http://fastapi_app:8000/orderdetails/{ordernr}')
    orderdetails = response.json()
    print(orderdetails) 
    return render(request, 'orderdetails.html', {'orderdetails': orderdetails})

def sportartikeldetails(request, artcode):
    response = requests.get(f'http://fastapi_app:8000/sportartikelen/{artcode}')
    plantdetails = response.json()
    getArtcode = plantdetails[0]['artcode']
    

    return render(request, 'plantdetails.html', {'plantdetails': plantdetails})

def sportartikelen(request):
    response = requests.get(f"http://fastapi_app:8000/sportartikelen")
    sportArtikelen = response.json()
    return render(request, 'sportartikelen.html', {'sportartikelen': sportArtikelen})

def orderdetailsArt(request, artcode):
    response = requests.get(f"http://fastapi_app:8000/orderdetailsArt/{artcode}")
    orderdetails = response.json()
    getOrderNr = orderdetails[0]['ordernr']
    response = requests.get(f'http://fastapi_app:8000/orderdetails/{getOrderNr}')
    orderdetails = response.json()
    return render(request, 'orderdetails.html', {'orderdetails': orderdetails})