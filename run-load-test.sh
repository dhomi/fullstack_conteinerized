#!/bin/bash

# Controleer of curl of wget beschikbaar is
if command -v curl >/dev/null 2>&1; then
    HTTP_CLIENT="curl -s -o /dev/null -w '%{http_code}'"
elif command -v wget >/dev/null 2>&1; then
    HTTP_CLIENT="wget --quiet --server-response --output-document=/dev/null"
else
    echo "Geen curl of wget gevonden. Installeer een van beide en probeer opnieuw."
    exit 1
fi

echo "Load test gestart voor 5 minuten..."

START_TIME=$(date +%s)
END_TIME=$((START_TIME + 300)) # 5 minuten = 300 seconden

while [ $(date +%s) -lt $END_TIME ]; do
    # Voer de request uit en controleer de HTTP-status
    if [ "$HTTP_CLIENT" = "curl -s -o /dev/null -w '%{http_code}'" ]; then
        STATUS_CODE=$($HTTP_CLIENT http://localhost:8000/suppliers)
    else
        STATUS_CODE=$(wget --server-response --output-document=/dev/null http://localhost:8000/suppliers 2>&1 | awk '/HTTP\/[0-9.]+/ {print $2}' | tail -1)
    fi

    # Log de response status
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "Success: Received HTTP $STATUS_CODE response"
    else
        echo "Test failed: Received HTTP $STATUS_CODE response"
    fi

    # Wacht 2 seconden voor de volgende request
    sleep 2
done

echo "Load test voltooid."
exit 0
