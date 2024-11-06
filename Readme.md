# Howto
Na het docker-compose ga naar het dashboard: http://localhost:4000/

## TODO
- chaos testing: https://github.com/chaos-mesh/chaos-mesh
- architectuur plaatje maken voor uitleggen wat/hoe dit werkt

## Installatie
Er wordt er vanuit gegaan dat je:
Docker desktop en NodeJS geinstalleerd zijn
Voor lokaal runnen is tooltje act wel erg handig <https://nektosact.com>

## Start de container
```docker-compose up --build```
aan het einde van de build zie je ook de Local IP en de Network IP

### Monitor
Grafana is op: http://localhost:4000

Monitoring dashboard is het 'TechLab backend monitor'
grafana haalt gegevens op uit InfluxDB:8086, en influx krijgt data elke paar seconden uit telegram scraper (op backend getall)

## Local IP adress ophalen
ipconfig | grep IPv4 | awk 'END{print}'  


### View de front- en backend 
Frontend zit op http://localhost:3000/ . De frontend krijgt de 'jokes' van de backend die op http://localhost:8000/ draait

Docker container stoppen met ```docker-compose down```

### E2E tests
in een shell ga naar de map e2e en run ze met act

```cd e2e
act
```
### JMeter
cd naar jmeter en start act op

```cd jmeter
act
```

### K8s (Kubernetes) opzet
doe een 'kubectl apply -f Deployment.yaml -n techlab' om het Techlab binnen K8s te installeren

## CRUD operaties testen

### Read (GET) all items, returns status: 200:
GET http://localhost:8000

### Read (GET) a specific item by ID, returns status: 200:
GET http://localhost:8000/6

### Create (POST) a new joke, returns status: 201:
POST http://localhost:8000
Body: {"item": "POST nieuwe mop" }

### Update (PUT) an item by ID, returns status: 200:
PUT http://localhost:8000/6
Body: { "item": "PUT update" }

### Delete (DELETE) an item by ID, returns status: 204:
DELETE http://localhost:8000/6
