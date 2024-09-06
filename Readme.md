# Howto

## TODO
chaos testing: https://github.com/chaos-mesh/chaos-mesh
Grafana met dashboard op backend elke 1 sec. GET

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

### View de front- en backend 
Frontend zit op http://localhost:3000/ . De frontend krijgt de 'items' van de backend die op http://localhost:8000/items draait

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

## CRUD operaties testen

### Read (GET) all items:
GET http://localhost:8000

### Read (GET) a specific item by ID:
GET http://localhost:8000/1

### Create (POST) a new item:
POST http://localhost:8000
Body: { "id":"12", "item": "New Item" }

### Update (PUT) an item by ID:
PUT http://localhost:8000/1
Body: { "id":"12", "item": "New Item" }

### Delete (DELETE) an item by ID:
DELETE http://localhost:8000/1
