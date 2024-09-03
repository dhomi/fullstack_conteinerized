# language: nl
@wip

Functionaliteit: Controle van de API-status
  als tester 
  wil ik verifieren dat de API-endpoints correct werken
  zodat ik weet dat de diensten operationeel zijn

  Abstract Scenario: Verifieer dat de API een statuscode 200 teruggeeft
    Gegeven dat ik het endpoint "<url>" heb
    Wanneer ik een GET-request naar de API stuur
    Dan zou de responsestatuscode 200 moeten zijn

Voorbeelden:
    | url |
    | https://localhost:8000/ |
    | https://localhost:8000/1 |
