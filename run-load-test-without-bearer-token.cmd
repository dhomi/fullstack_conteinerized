@echo off
:: Start load test
echo Starting load test for 5 minutes...
set "starttime=%time%"
for /F "tokens=1-3 delims=:." %%a in ("%starttime%") do (
    set /A "hh=%%a, mm=%%b, ss=%%c"
)
set /A "mm+=5"
if %mm% GEQ 60 (
    set /A "mm-=60, hh+=1"
)

:loop
for /F "tokens=1-3 delims=:." %%a in ("%time%") do (
    if %%b GEQ %mm% if %%a GEQ %hh% goto done
)

:: Poll for Bearer Token
echo Polling for Bearer Token...
set "BEARER_TOKEN="

for /L %%i in (1,1,12) do (
    echo Attempt %%i: Sending request to http://localhost:8000/users/login

    :: PowerShell om de access_token op te halen
    for /F "delims=" %%j in ('powershell -Command "$response = Invoke-WebRequest -Uri 'http://localhost:8000/users/login' -Method POST -Headers @{'Accept'='application/json'; 'Content-Type'='application/x-www-form-urlencoded'} -Body 'grant_type=&username=QA-Techlab&password=Techlab&scope=&client_id=&client_secret=' -UseBasicParsing; ($response.Content | ConvertFrom-Json).access_token"') do set "BEARER_TOKEN=%%j"

    if defined BEARER_TOKEN (
        echo Bearer Token: %BEARER_TOKEN%
        echo ##vso[task.setvariable variable=bearerToken]%BEARER_TOKEN%
        goto send_requests
    )

    echo Bearer Token not available yet. Waiting for 15 seconds...
    timeout /T 15 /NOBREAK >nul
)

echo Failed to get Bearer Token within the timeout period.
exit /b 1

:send_requests
:: Stuur request naar de API en controleer statuscode
powershell -Command "$token='Bearer %BEARER_TOKEN%'; $response = Invoke-WebRequest -Uri 'http://localhost:8000/suppliers/' -Headers @{Authorization=$token} -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host 'Success: Received HTTP 200 response' } else { Write-Host 'Test failed: Received HTTP ' $response.StatusCode ' response' }"

:: Wacht 2 seconden voor de volgende aanvraag
timeout /T 2 /NOBREAK >nul
goto loop

:done
echo Load test completed successfully.
exit /b 0
