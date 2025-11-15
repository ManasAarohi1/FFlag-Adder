@echo off
title FFlag Applier
setlocal

:: Path to your JSON file
set "SOURCE_JSON=%~dp0IxpSettings.json"

:: Target folder
set "TARGET_FOLDER=%LOCALAPPDATA%\Roblox\ClientSettings"

echo =================================================
echo             FFlag Applier
echo =================================================
echo Press 1 to APPLY FFlags
echo Press 2 to REMOVE all FFlags
echo =================================================

choice /C 12 /N /M "Choose: "

if errorlevel 2 goto remove_fflags
if errorlevel 1 goto apply_fflags


:apply_fflags
echo Applying IxpSettings.json to %TARGET_FOLDER% ...
if not exist "%TARGET_FOLDER%" (
    mkdir "%TARGET_FOLDER%" >nul 2>&1
)
copy /Y "%SOURCE_JSON%" "%TARGET_FOLDER%\IxpSettings.json" >nul
echo Done applying FFlags!
pause
goto :eof


:remove_fflags
echo Removing IxpSettings.json from %TARGET_FOLDER% ...
if exist "%TARGET_FOLDER%\IxpSettings.json" (
    del /f /q "%TARGET_FOLDER%\IxpSettings.json"
    echo Removed IxpSettings.json
) else (
    echo No IxpSettings.json found to remove.
)
pause
goto :eof
