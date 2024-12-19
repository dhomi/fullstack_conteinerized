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

REM Docker desktop
choco install docker-desktop

REM Kubernetes tools
choco install kubernetes-cli

REM Act
choco install act-cli