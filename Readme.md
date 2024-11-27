![logo](src/qa.png)

# Fullstack Containerized Project

This repository is an ongoing CI/CD project with fullstack technology examples in an containerized environment. 

## How-To
Follow the instructions below. 

### Installation
Preconditions:
- [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/) installed
- [NodeJS](https://nodejs.org/en/download/package-manager) installed
- Act is a very handy tool for local running, see <https://nektosact.com>

### Start the container
```docker-compose up --build```
- After "docker-compose" go to dashboard at http://localhost:4000/
- At the end of the build you will also see the Local IP and the Network IP

### K8s (Kubernetes) opzet
maak de namespace aan: kubectl create namespace techlab
doe een 'kubectl apply -f deployment.yaml -n techlab' om het Techlab binnen K8s te installeren
check dat alle pods draaien: kubectl -n techlab get pods

port forward middleware:  kubectl port-forward -n techlab svc/middleware-fastapi 8000:8000
port forward frontend: kubectl port-forward svc/frontend-django -n techlab 8001:8001

## Helm install gebruiken om Techlab te starten ipv kubectl
https://www.youtube.com/watch?v=SLlYDL573sw
https://github.com/quickbooks2018/helmify

...vanuit gaande dat je helm al geinstalleerd hebt...
helm install techlab-release techhelm -n techlab


### Chaos testing
...vanuit gaande dat de docker runt, kubernetes ook en kubectl apply is uitgevoerd...

https://chaos-mesh.org/docs/production-installation-using-helm/

start de chaos dashboard:  kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333
ga naar het dashboard:  http://127.0.0.1:2333/
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

## Testing CRUD operations

### Read (GET) all items / returns status: 200
GET http://localhost:8000

### Read (GET) a specific item by ID / returns status: 200
GET http://localhost:8000/6

### Create (POST) a new joke / returns status: 201
POST http://localhost:8000
- Body: {"item": "POST nieuwe mop" }

### Update (PUT) an item by ID / returns status: 200
PUT http://localhost:8000/6
- Body: { "item": "PUT update" }

### Delete (DELETE) an item by ID / returns status: 204
DELETE http://localhost:8000/6

## TODO
- Chaos testing: https://github.com/chaos-mesh/chaos-mesh
- Create an architectural picture to explain what and how this project works
- Extra README instructions