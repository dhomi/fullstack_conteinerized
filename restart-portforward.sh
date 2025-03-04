#!/bin/bash

# Stop port forwarding
pkill -f "kubectl" > /dev/null 2>&1

# Start port forwarding
kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333 &
kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000 &
kubectl port-forward -n techlab svc/grafana 4000:4000 &
kubectl port-forward -n techlab svc/frontend-django 8001:8001 &
kubectl port-forward -n techlab svc/db 3306:3306 &

# Houd de terminal open
wait