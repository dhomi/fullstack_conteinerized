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