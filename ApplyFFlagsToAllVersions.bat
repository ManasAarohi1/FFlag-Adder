@echo off
title FFlag Applier
setlocal enabledelayedexpansion

:: Path to your JSON file
set "SOURCE_JSON=%~dp0IxpSettings.json"

:: List of known bootstrapper version paths
set "BOOTSTRAP_PATHS=%localappdata%\Roblox\Versions"
set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%localappdata%\Bloxstrap\Versions"
set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%localappdata%\Fishstrap\Versions"
set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%localappdata%\Voidstrap\Versions"

:: Also search %localappdata% and %appdata% for any "version-*" folders
for /d %%D in ("%localappdata%\*") do (
    if exist "%%D\version-*" (
        set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%%D"
    )
)
for /d %%D in ("%appdata%\*") do (
    if exist "%%D\version-*" (
        set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%%D"
    )
)

echo =================================================
echo             FFlag Applier 
echo =================================================
echo Press 1 to APPLY IxpSettings.json
echo Press 2 to REMOVE all IxpSettings.json
echo =================================================

choice /C 12 /N /M "Choose: "

if errorlevel 2 goto remove_ixp
if errorlevel 1 goto apply_ixp

:apply_ixp
echo Applying IxpSettings.json to all detected Roblox versions...
for %%P in (%BOOTSTRAP_PATHS%) do (
    if exist "%%P" (
        for /d %%V in ("%%P\version-*") do (
            echo Patching %%V ...
            mkdir "%%V\ClientSettings" >nul 2>&1
            copy /Y "%SOURCE_JSON%" "%%V\ClientSettings\IxpSettings.json" >nul
        )
    )
)
echo Done applying IxpSettings.json!
pause
goto :eof

:remove_ixp
echo Removing IxpSettings.json from all detected Roblox versions...
for %%P in (%BOOTSTRAP_PATHS%) do (
    if exist "%%P" (
        for /d %%V in ("%%P\version-*") do (
            if exist "%%V\ClientSettings\IxpSettings.json" (
                del /f /q "%%V\ClientSettings\IxpSettings.json"
                echo Removed from %%V
            )
        )
    )
)
echo Done removing IxpSettings.json!
pause
goto :eof
