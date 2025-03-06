@echo off
:: Start load test
echo Starting load test for 5 minutes...
set "starttime=%time%"
for /F "tokens=1-4 delims=:.," %%a in ("%starttime%") do (
    set /A "hh=%%a, mm=%%b, ss=%%c, ms=%%d"
)
set /A "mm+=5"
if %mm% GTR 59 (set /A "mm-=60, hh+=1")

:loop
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
    if %%b GEQ %mm% if %%a GEQ %hh% goto done
)

:: Send request using PowerShell and check response status
for /F %%s in ('powershell -Command "(Invoke-WebRequest -Uri 'http://localhost:8000/suppliers' -UseBasicParsing).StatusCode"') do (
    if %%s EQU 200 (
        echo Success: Received HTTP %%s response
    ) else (
        echo Test failed: Received HTTP %%s response
    )
)

:: Wait for 2 seconds before next request
powershell -Command "Start-Sleep -Seconds 2"
goto loop

:done
echo Load test completed successfully.
exit /b 0
