# Howto
## Start de container
```docker-compose up --build```

aan het einde van de build zie je ook de Local IP en de Network IP

## View de front- en backend 
Open http://localhost:3000/ om de QA jokesville frontend te zien die de jokes krijgt van de backend die op http://localhost:8000/ de output heeft

Hierna kan je de ```docker-compose up``` (zonder ```--build```) gebruiken
## Stop de container
```docker-compose down```