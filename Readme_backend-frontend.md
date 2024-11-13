# QA - Techlab

## Overzicht

Dit project bevat een API, gebouwd met de Python-bibliotheek FastAPI, die een RESTful-interface biedt voor interactie met een MySQL-database. De database bevat gegevens over sportartikelen, klanten, leveranciers en bestellingen. Deze API ondersteunt momenteel alleen **GET**-verzoeken op een aantal tabellen; uitbreiding naar volledige CRUD-functionaliteit is gepland.

## Inhoud
1. [Project Status en To-Do's](#project-status-en-to-dos)
2. [Database Uitleg](#database-uitleg)
3. [Backend Configuratie](#backend-configuratie)
4. [Frontend Configuratie](#frontend-configuratie)
5. [API Endpoints](#api-endpoints)
6. [Vereisten en Installatie](#vereisten-en-installatie)

---

## Project Status en To-Do's

- **Swagger API**:
  - Momenteel werken alleen de GET-requests voor enkele tabellen.
  - De POST-, PUT-, en DELETE-functionaliteit moet nog worden geïmplementeerd.
  - In de toekomst kunnen er meer tabellen en functionaliteit worden toegevoegd.

- **Database**:
  - Enkele tabellen en gegevens, zoals prijzen, zijn aangepast ten opzichte van de originele database en worden nog geoptimaliseerd.

## Database Uitleg

De `QAsportartikelen` database is bedoeld voor het beheren van sportartikelen en het ondersteunen van het verkoopproces. Deze database kan worden gebruikt voor:

1. **Voorraadbeheer**: Houd bij hoeveel producten zijn ingekocht en op voorraad zijn. Zo weet je precies wat er nog beschikbaar is en wat eventueel moet worden bijbesteld.
2. **Verkoopregistratie**: Registreer klantenaankopen en krijg inzicht in wie wat heeft gekocht en wanneer. Dit helpt bij het analyseren van populaire producten en klantloyaliteit.
3. **Orderbeheer**: Volg bestellingen en leveringen van leveranciers. Handig om te weten welke bestellingen onderweg zijn en wanneer deze binnenkomen.
4. **Klantoverzicht (CRM)**: Creëer een basis-klantenoverzicht met aankoopgeschiedenis, zodat je meer inzicht hebt in het koopgedrag van klanten.

## Backend Configuratie

- De MySQL-database draait op `localhost:3306`.
- Toegang tot de database via de web-UI: [http://localhost:8090](http://localhost:8090)
  - **Gebruiker**: `root`
  - **Wachtwoord**: `password`
- **Eerste keer database laden**:
    1. Ga naar [http://localhost:8090](http://localhost:8090) en log in.
    2. Navigeer naar de `Import`-sectie.
    3. Upload het bestand `QA_sportartikelen_v1.2.sql` (te vinden in `app/mysql/`).
    4. Klik op `Import`.
    5. Controleer of de `QAsportartikelen` database is toegevoegd aan de lijst.

## Frontend Configuratie

- Toegang tot de front-end interface via [http://localhost:8001](http://localhost:8001).
- De front-end ondersteunt momenteel nog geen volledige functionaliteit voor POST-, PUT- en DELETE-verzoeken.

## API Endpoints

Hier zijn de beschikbare API-endpoints die interactie bieden met de database:

- **Swagger-overzicht**:
  - Ga naar [http://localhost:8000/docs](http://localhost:8000/docs) voor een overzicht van alle endpoints.

### Beschikbare Endpoints

1. **Leveranciers ophalen**  
   **GET** `/suppliers`  
   Haalt een lijst van alle leveranciers in de database op.

2. **Bestellingen ophalen**  
   **GET** `/orders`  
   Haalt alle bestellingen in de database op.

3. **Bestellingsdetails ophalen**  
   **GET** `/ordersdetails/{ordernr}`  
   Haalt details op voor een specifieke bestelling. De response bevat informatie zoals leverancierscode, bestelnummer, artikelcode, artikelnaam, hoeveelheid, prijs, besteldatum, leverdatum en status.

4. **Artikelnaam-details ophalen**  
   **GET** `/artikelnaam/{artcode}`  
   Haalt details op van een specifiek artikel, inclusief informatie zoals artikelnaam, hoogte, levensduur, kleur, onderhoudsinstructies, kosten, verkoopprijs en type.

## Vereisten en Installatie

1. **Installeer Docker Desktop**: [Download hier](https://www.docker.com/)
2. **Start de server**:
   - Gebruik de volgende opdracht in PowerShell om de server te starten:
     ```bash
     docker-compose up
     ```
3. **API Testen**:
   - Zodra de server actief is, kun je de API benaderen via [http://localhost:8000](http://localhost:8000).