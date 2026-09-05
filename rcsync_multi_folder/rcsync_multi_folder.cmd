@echo off
setlocal enabledelayedexpansion
set moddate=2025-09-05
echo.
echo.
echo ---------------------------------------------------------
echo.
echo     Robocopy-Kopierroutine
echo     %moddate%
echo.
echo ---------------------------------------------------------
echo.
echo Das Fenster wird bei Programmende automatisch geschlossen!
echo.

rem created  at 2020-02-27 by aviateur
rem modified at 2020-05-14 by aviateur; Ordner erzeugen, wenn er nicht existiert
rem published at 2023-03-04 by aviateur
rem modified at 2025-09-05; robustere Fehlerauswertung, Quoting, Existenzpruefung

rem Benoetigte Dateien:
rem - SourceDest.txt: Vorlage fuer Quelle, Ziel, ...
rem   SOURCE=%%a
rem   FILE=%%b
rem   DEST=%%c          - ohne den Teil unter %SYNCPATH%
rem   LOGF=%%d_%Tstamp%
rem   SWITCH=%%e
rem   MSG=%%f

rem in aktuelles Verzeichnis wechseln
cd /d %~d0%~p0

rem Timestamp erstellen

Set DYYYY=%date:~6,4%
Set DMM=%date:~3,2%
Set DDD=%date:~0,2%
Set Thh1=%time:~0,1%
Set Thh2=%time:~1,1%
Set Tmm=%time:~3,2%
Set Tss=%time:~6,2%

if "%Thh1%"==" " set Thh1=0

set Tstamp=%DYYYY%-%DMM%-%DDD%~%Thh1%%Thh2%-%Tmm%

rem Pfade festlegen (ohne abschliessenden Backslash)

set LOGD=c:\temp

if not exist "%LOGD%" mkdir "%LOGD%"

rem Steuerdatei

set "file0=%~dp0SourceDest.txt"

if not exist "%file0%" (
    echo.
    echo FEHLER: Steuerdatei nicht gefunden:
    echo   "%file0%"
    echo Es wurde nichts kopiert.
    echo.
    pause
    exit /b 1
)

rem Zaehler fuer die Zusammenfassung
set /a JOBS=0
set /a FAILED=0
set "FAILLIST="

rem Kopier-Schleife
for /f "usebackq eol=# tokens=1-6 delims=;" %%a in ("%file0%") do (
    set /a JOBS+=1
    echo.
    echo %%f

    if not exist "%%c" (
        mkdir "%%c" 2>nul
        if not exist "%%c" (
            echo   FEHLER: Zielordner "%%c" konnte nicht angelegt werden - Job wird uebersprungen.
            set /a FAILED+=1
            set "FAILLIST=!FAILLIST! %%c"
        )
    )

    if exist "%%c" (
        robocopy "%%a" "%%c" "%%b" %%e /log+:"%LOGD%\%%d_%Tstamp%.log"
        set RC=!errorlevel!
        if !RC! GEQ 8 (
            echo   FEHLER: Robocopy meldet Fehlercode !RC! fuer "%%c" - siehe Logfile.
            set /a FAILED+=1
            set "FAILLIST=!FAILLIST! %%c"
        )
    )
)

echo.
echo ---------------------------------------------------------
if %FAILED% GTR 0 (
    echo   FERTIG MIT FEHLERN: %FAILED% von %JOBS% Job(s) fehlgeschlagen.
    echo   Betroffene Ziele:!FAILLIST!
    echo   Bitte Logfiles in "%LOGD%" pruefen.
) else (
    echo   Fertig! Alle %JOBS% Ordner wurden erfolgreich gespiegelt.
)
echo ---------------------------------------------------------
echo.

rem pause

set "EXITCODE=0"
if %FAILED% GTR 0 set "EXITCODE=1"
endlocal & exit /b %EXITCODE%
