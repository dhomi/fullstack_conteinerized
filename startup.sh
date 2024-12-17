#!/usr/bin/env bash

# Check if Helm is installed
if ! helm version > /dev/null 2>&1; then
    echo "Helm is not installed. Installing Helm..."

    # Install Helm
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
else
    echo "Helm is already installed."
fi

# Create both namespaces
# Check if namespace techlab exists, if not, create it
if ! kubectl get namespace techlab; then
  kubectl create namespace techlab
fi

# Apply the deployment in the techlab namespace
kubectl apply -f deployment.yaml -n techlab

# Get the pods in the techlab namespace
kubectl -n techlab get pods

# Check if namespace chaos-mesh exists, if not, create it
if ! kubectl get namespace chaos-mesh; then
  kubectl create namespace chaos-mesh
fi

# Add Helm repo and install/upgrade Chaos Mesh
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 &
helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

# Wait for 2 minutes to ensure services are up
sleep 2m

# Port forwarding
kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333 &
kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000 &
kubectl port-forward -n techlab svc/grafana 4000:4000 &
kubectl port-forward -n techlab svc/frontend-django 8001:8001 &