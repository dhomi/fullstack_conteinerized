#!/usr/bin/env bash

# create both namespaces
kubectl create namespace techlab --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace chaos-mesh --dry-run=client -o yaml | kubectl apply -f -

# Deploy all
kubectl apply -f deployment.yaml -n techlab

kubectl -n techlab get pods

# Configureer Chaos Mesh
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0
helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.service.type=LoadBalancer --set dashboard.securityMode=false --set dashboard.service.port=80 --set dashboard.service.targetPort=2333