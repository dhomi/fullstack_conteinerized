@echo off


REM Create both namespaces
REM Check if namespace techlab exists, if not, create it
kubectl get namespace techlab >nul 2>&1
if %errorlevel% neq 0 (
  kubectl create namespace techlab
)

REM Apply the deployment in the techlab namespace
kubectl apply -f deployment.yaml -n techlab

REM Get the pods in the techlab namespace
kubectl -n techlab get pods

REM Check if namespace chaos-mesh exists, if not, create it
kubectl get namespace chaos-mesh >nul 2>&1
if %errorlevel% neq 0 (
  kubectl create namespace chaos-mesh
)

REM Add Helm repo and install/upgrade Chaos Mesh
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0
helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

REM Wait for 1 minute to ensure services are up
timeout /t 60

REM Port forwarding
start /b kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333
start /b kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
start /b kubectl port-forward -n techlab svc/grafana 4000:4000
start /b kubectl port-forward -n techlab svc/frontend-django 8001:8001
start /b kubectl port-forward -n techlab svc/db 3306:3306

REM Houd de terminal open
pause