@echo off

REM Stop port forwarding
taskkill /F /IM "kubectl.exe" >nul 2>&1

REM Delete both namespaces
kubectl delete namespace techlab
helm uninstall chaos-mesh -n=chaos-mesh
REM kubectl delete namespace chaos-mesh

REM Remove Helm repo
helm repo remove chaos-mesh

REM Houd de terminal open
pause