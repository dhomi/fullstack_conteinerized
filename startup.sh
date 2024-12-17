#!/usr/bin/env bash

# install helm first
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# create both namespaces
kubectl create namespace techlab
kubectl apply -f deployment.yaml -n techlab
kubectl -n techlab get pods
kubectl create ns chaos-mesh

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 &
helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

# todo: hier moet de terminal effe een tijd wachten totdat alles hierboven is uitgevoerd 
# anders start de port forwarding maar de services is nog down...
sleep 2m # Waits 2 minutes.

# port forwarding
kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333 &
kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000 &
kubectl port-forward -n techlab svc/grafana 4000:4000 &
kubectl port-forward -n techlab svc/frontend-django 8001:8001 &