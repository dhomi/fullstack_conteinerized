@echo off

REM create both namespaces
kubectl create namespace techlab
kubectl apply -f deployment.yaml -n techlab
kubectl -n techlab get pods
kubectl create ns chaos-mesh

REM vergeet niet eerst helm zelf te installeren!
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

REM todo: hier moet de terminal effe een tijd wachten totdat alles hierboven is uitgevoerd 
REM anders start de port forwarding maar de services is nog down...
timeout /t 120

REM port forwarding
start /b kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333
start /b kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
start /b kubectl port-forward -n techlab svc/grafana 4000:4000
start /b kubectl port-forward -n techlab svc/frontend-django 8001:8001

REM Houd de terminal open
pause