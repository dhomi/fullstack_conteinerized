![logo](src/qa.png)

# Fullstack Containerized Project

This repository is an ongoing CI/CD project with fullstack technology examples in an containerized environment. 

### Installation
Preconditions:
- [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
- Kubernetes tools als [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm] (https://helm.sh/docs/intro/install/)
- Act is handig voor het github actions lokaal runnen:[ACT] (https://nektosact.com)

- Als je wil ontwikkelen: 
  - [NodeJS](https://nodejs.org/en/download/package-manager)
  - [Python] (https://docs.python-guide.org/starting/install3/)

handig om te zien welke pods en services aan zijn in k8:  
    kubectl get all -o wide -n techlab
### Gebruik het startup.sh shell script
open een git-shell terminal, of een bash. startup.sh moet executable zijn, je kan het handmatig ook doen:  chmod +x startup.sh
dan start je het op door:  
    ./startup.sh
### K8s (Kubernetes)
- Docker desktop met Kubernetes is running
- maak de namespace aan: kubectl create namespace techlab
- start de k8: kubectl apply -f deployment.yaml -n techlab
- check status van pods: kubectl -n techlab get pods

port forward middleware:  kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
port forward frontend: kubectl port-forward svc/frontend-django -n techlab 8001:8001

### Chaos testing
...vanuit gaande dat de docker runt, kubernetes ook en kubectl apply is uitgevoerd...
Start eerst het techlab en ga daarna verder om Chaos Mesh te installeren!

https://chaos-mesh.org/docs/production-installation-using-helm/
of doe: 
- kubectl create ns chaos-mesh
- helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0
- helm upgrade chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version 2.7.0 --set dashboard.securityMode=false

kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333

dashboard is dus hier te zien: http://127.0.0.1:2333/

via UI/dashboard: Selecteer de techlab namespace, en de grafana app. 
Maak een experiment door POD KIlL en Submit deze allemaal 

CLI:
...zorg dat de betreffende name van een chaos experiment eerst ge-archived is in de experiments dashboard van de chaos mesh...
cd chaos/
kubectl apply -f ./kill_grafana_pod.yaml

check de grafana pod in de docker ui. hij moet exited zijn, en binnen enkele seconden een nieuwe pod is running.

### Monitor
Grafana is a monitoring tool at http://localhost:4000

- Monitoring dashboard is the 'TechLab backend monitor'
- Grafana gets data from InfluxDB:8086, and Influx gets data every few seconds from Telegram scraper (on backend number)

### Fetch Local IP address
```ipconfig | grep IPv4 | awk 'END{print}'```  


### View the Front- and Backend 
- Frontend is located at http://localhost:3000/
- The frontend gets the 'jokes' from the backend that runs on http://localhost:8000/
- To stop the Docker container:
 ```docker-compose down```

### E2E tests
From the shell (or other CLI tool) navigate to folder "e2e" and run the test with "act"

```cd e2e
act
```
### JMeter
Navigate to folder "jmeter" and start "act"

```cd jmeter
act
```
### als de containers niet lukken
Start the container: docker-compose up --build
- After "docker-compose" go to dashboard at http://localhost:4000/
- At the end of the build you will also see the Local IP and the Network IP

## TODO
- Chaos testing: https://github.com/chaos-mesh/chaos-mesh
- Create an architectural picture to explain what and how this project works
- Extra README instructions
- Wait time or time sleep when you execute the startup.sh. when you start the first time the script it doesnt wait till the pod is deployed with the status running. It will throw an error.