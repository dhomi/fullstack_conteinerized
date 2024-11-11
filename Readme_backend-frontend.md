Welcome to QA's Techlab playground

TO DO:
- Uitleg backend: localhost:8090
- Uitleg front-end: localhost: 8001

Overzicht

Dit is een API gebouwd met de FastAPI-bibliotheek in Python, die een RESTful-interface biedt voor interactie met een MySQL-database. De database bevat informatie over leveranciers en bestellingen, en de API biedt methoden voor het uitvoeren van CRUD-bewerkingen op deze gegevens.

Vereisten Installeer Docker Desktop -> https://www.docker.com/
Start Docker met de volgende opdracht in PowerShell:

    docker-compose up

Wanneer de server actief is, kun je de API benaderen via http://localhost:8000.

Endpoints

De volgende endpoints zijn beschikbaar voor interactie met de database:

    Leveranciers ophalen
    /suppliers (GET):
    Dit endpoint retourneert alle leveranciers in de database.

    Bestellingen ophalen
    /orders (GET):
    Dit endpoint retourneert alle bestellingen in de database.

    Bestellingsdetails ophalen
    GET /ordersdetails/{ordernr}
    Dit endpoint wordt gebruikt om de details van een bestelling met het bestelnummer ordernr op te halen. De respons bevat details zoals leverancierscode, bestelnummer, artikelcode, artikelnaam, hoeveelheid, bestellingsprijs, besteldatum, leverdatum, prijs en status. Dit endpoint accepteert de volgende queryparameters:

    Artikelnaam-details ophalen
    GET /artikelnaam/{artcode}
    Dit endpoint wordt gebruikt om de details van een artikel op te halen met de artikelcode artcode. De respons bevat details zoals artikelcode, artikelnaam, hoogte, levensduur, kleur, onderhoudsinstructies, kosten, verkoopprijs en soort.