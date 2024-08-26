# Howto

Er wordt er vanuit gegaan dat je:
Docker desktop en NodeJS geinstalleerd zijn

## Start de container
```docker-compose up --build```

aan het einde van de build zie je ook de Local IP en de Network IP

### Stop de container
```docker-compose down```

## View de front- en backend 
Frontend zit op http://localhost:3000/ . De frontend krijgt de 'items' van de backend die op http://localhost:8000/items draait


## CRUD operaties testen

### Read (GET) all items:
GET http://localhost:8000

Read (GET) a specific item by ID:
GET http://localhost:8000/1

### Create (POST) a new item:
POST http://localhost:8000
Body: { "id":"12", "item": "New Item" }

### Update (PUT) an item by ID:
PUT http://localhost:8000/1
Body: { "id":"12", "item": "New Item" }

### Delete (DELETE) an item by ID:
DELETE http://localhost:8000/1


POST http://localhost:8000
Body: { "id":"12", "item": "New Item" }
