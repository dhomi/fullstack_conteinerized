@echo off

REM Preconditions
REM [Install Chocolatey](https://chocolatey.org/install)

REM Docker desktop
choco install docker-desktop

REM Kubernetes tools
choco install kubernetes-cli

REM Helm
choco install kubernetes-helm

REM Act
choco install act-cli
