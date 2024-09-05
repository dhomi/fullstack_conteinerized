# DSO End to end test

## Inhoud

- Installatie
- Test uitvoeren
- Ontwikkeling
  - WIP: Work in progress
- Pipeline
- BDD
- Docker test runs
- TODO Framework en pipeline
- TODO Feature files

## Installatie

Ten eerste deze repository verkrijgen door het

- zip bestand te downloaden
- of door het Pull-en met git, installeer dus Git eerst: https://git-scm.com/downloads
  - Lees verder `Optie 2. Lokaal installeren`

### Optie 1. Docker

- Installeer Docker: https://docs.docker.com/desktop/

#### Docker container bouwen

Het is mogelijk om een docker container te builden dmv. de `Dockerfile` en daarin de tests te kopiëren en runnen

- Bouwen van de Container: `docker build -t playwright-docker .`
- Test uitvoeren in deze container: `docker run -it playwright-docker:latest npm run test`

### Optie 2. Lokaal installeren

- NodeJS: https://nodejs.org/en/download

```
  git clone https://gitlab.cicd.s15m.nl/rws/dso/projecten/dso-e2e.git
  cd dso-e2e
  npm install
  npx playwright install
```

## Test uitvoeren

Er zijn twee manieren van het runnen van de tests:

### Optie 1. Ze in Docker te runnen.

Dan heb je geen lokale NodeJS en Playwright nodig.

- Test uitvoeren in deze container: `docker run -it playwright-docker:latest npm run test`

### Optie 2

In een lokale installatie waar NodeJS en Playwright geïnstalleerd zijn

- Api test uitvoeren `npm run test`
- WorkInProgress (tag: wip) tests uitvoeren `npm run test:wip`
- Vergunningcheck uitvoeren. Deze functie zit in de performance meting test `npm run performance`
- Inloggen en aanvraag indienen / Algemene Set test uitvoeren`npm run inloggen`

Zie verder het package.json bestand om te begrijpen welke `scripts` er zijn en hoe deze zijn opgebouwd

## Ontwikkeling

### Settings van Playwright aanpassen

Zie het bestand: `playwright.config.ts`

### DSO test Tags

Belangrijke tags zijn de capabilities zoals genoemd in: https://jira.team-dso.nl/confluence/pages/viewpage.action?spaceKey=TEST&title=Capabilities

### Wip: Work in progress

De tests met het tag: `@wip` kan je runnen door commando (in package.json is dat een script): `npm run wip`

## Pipeline

De .gitlab-ci.yml is onze pipeline yaml script. Daarin zijn twee jobs aangemaakt:

- `performance:on-schedule` runt als de scheduler deze aftrapt
- `playwright` runt normaal met elke andere run bv. commit, merge ezv.

## Testtypes

## BDD

- `./features/` map: Scenarios zijn in de 'features' map in het Nederlands
- `./steps/` map: Stappen in typescript & playwright

Als je en feature file maakt en deze uitvoert zonder de benodigde steps, dan faalt ie maar er is ook goed nieuws:
playwright geeft je de inhoud van de benodigde steps bestand in de log ;)

Uitgangspunten:

- Fixtures opnemen in pipeline en framework
- zo min mogelijk data en technische afhankelijkheid in het framework
- gebruik waar mogelijk de publieke applicaties van het Omgevingsloket

## TODO Framework en pipeline

Credentials opslaan in de gitlab vault ipv. repository

## TODO Feature files

Epics vanuit Kadaster:

- BC2.1 - Kunnen opstellen en indienen van aanvragen en meldingen
  See: https://tbokadaster.atlassian.net/wiki/spaces/SRT/pages/377552898/BC2.1+-+Kunnen+opstellen+en+indienen+van+aanvragen+en+meldingen
  - Omgevingsloket Inloggen
  - Omgevingsloket-ID aanvragen
  - 
- BC2.2 - Kunnen bewaren van info tijdens opstellen van aanvragen en meldingen
- BC2.3 - Kunnen samenwerken tijdens opstellen van aanvragen en meldingen
- BC2.4 - Kunnen valideren van indieningsvereisten van aanvragen en meldingen
- BC2.5 - Beschikbaar stellen van publiceerbare aanvragen en meldingen
- BC2.6 - Kunnen samenwerken tijdens behandelen van aanvragen en meldingen
