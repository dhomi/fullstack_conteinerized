@echo off

REM Stop port forwarding
taskkill /F /IM "kubectl.exe" >nul 2>&1

REM Port forwarding
start /b kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333
start /b kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
start /b kubectl port-forward -n techlab svc/grafana 4000:4000
start /b kubectl port-forward -n techlab svc/frontend-django 8001:8001
start /b kubectl port-forward -n techlab svc/db 3306:3306

REM Houd de terminal open
pause