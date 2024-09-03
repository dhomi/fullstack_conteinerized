# language: nl

Functionaliteit: UI check
  als tester 
  wil ik verifieren dat de ui correct werkt

@wip
  Abstract Scenario: Verifieer dat bepaalde UI componenten juist werken
    Gegeven dat ik de URL "<url>" open
    Wanneer ik een op een card klik
    Dan zou de geklikte id '1' moeten zijn
    Dan zouden de opvolgende kliks met +1 verhoogd worden

Voorbeelden:
    | url |
    | http://localhost:3000 |

