@echo off

REM Check if Helm and Choco is installed
helm version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    REM Helm is not installed, proceed with installation

    REM Install Chocolatey if not already installed
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

    REM Install Helm using Chocolatey
    choco install kubernetes-helm -y
) ELSE (
    echo Helm is already installed.
)

REM Check if Docker Desktop is installed
docker --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker Desktop is not installed. Installing...
    choco install docker-desktop
) else (
    echo Docker Desktop is already installed.
)

REM Check if Kubernetes CLI is installed
kubectl version --client > nul 2>&1
if %errorlevel% neq 0 (
    echo Kubernetes CLI is not installed. Installing...
    choco install kubernetes-cli
) else (
    echo Kubernetes CLI is already installed.
)

REM Check if Act CLI is installed
act --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Act CLI is not installed. Installing...
    choco install act-cli
) else (
    echo Act CLI is already installed.
)
