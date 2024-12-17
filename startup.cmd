@echo off

:: Install Chocolatey if not already installed
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

:: Install Helm using Chocolatey
choco install kubernetes-helm -y

:: Create both namespaces
kubectl create namespace techlab
kubectl apply -f deployment.yaml -n techlab
kubectl -n techlab get pods
kubectl create ns chaos-mesh

:: Add Helm repo and install/upgrade Chaos Mesh
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0
helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

:: Wait for 2 minutes to ensure services are up
timeout /t 120

:: Port forwarding
start /b kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333
start /b kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
start /b kubectl port-forward -n techlab svc/grafana 4000:4000
start /b kubectl port-forward -n techlab svc/frontend-django 8001:8001

REM Houd de terminal open
pause