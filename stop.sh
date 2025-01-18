#!/bin/bash

# Stop port forwarding
pkill -f "kubectl port-forward"

# Delete both namespaces
kubectl delete namespace techlab
kubectl delete namespace chaos-mesh

# Remove Helm repo
helm repo remove chaos-mesh

# Keep the terminal open
read -p "Press any key to continue..."