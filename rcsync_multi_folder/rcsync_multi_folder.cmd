@echo off
set moddate=2023-03-04
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


rem Benötigte Dateien:
rem - SourceDest.txt: Vorlage für Quelle, Ziel, ...
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


rem Pfade festlegen (ohne abschliessenden Backslach)

rem set SYNCPATH=C:
set LOGD=c:\temp

rem if not exist %SYNCPATH% (
rem   mkdir %SYNCPATH%
rem ) else (
rem   cd %SYNCPATH%
rem )

rem Kopier-Schleife
set "file0=%~dp0\SourceDest.txt"
set l=C:\temp

for /f "usebackq eol=# tokens=1-6 delims=;" %%a in ("%file0%") do (
	echo.
    echo %%f
	if not exist %%c mkdir %%c
    robocopy "%%a" "%%c" "%%b" %%e /log+:"%LOGD%\%%d_%Tstamp%.log")
    	
rem explorer %SYNCPATH%
rem explorer C:\TEMP

:meldung
echo.
if %errorlevel% NEQ 0 (
echo errorlevel: %errorlevel%
)
echo.
echo Fertig!
echo nun sollten alle Ordner gespiegelt sein
echo.
rem pause

