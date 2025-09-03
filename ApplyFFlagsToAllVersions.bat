@echo off
title FFlag Applier
setlocal enabledelayedexpansion

:: Path to your JSON file
set "SOURCE_JSON=%~dp0ClientAppSettings.json"

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
echo Press 1 to APPLY FFlags
echo Press 2 to REMOVE all FFlags
echo =================================================

choice /C 12 /N /M "Choose: "

if errorlevel 2 goto remove_fflags
if errorlevel 1 goto apply_fflags

:apply_fflags
echo Applying ClientAppSettings.json to all detected Roblox versions...
for %%P in (%BOOTSTRAP_PATHS%) do (
    if exist "%%P" (
        for /d %%V in ("%%P\version-*") do (
            echo Patching %%V ...
            mkdir "%%V\ClientSettings" >nul 2>&1
            copy /Y "%SOURCE_JSON%" "%%V\ClientSettings\ClientAppSettings.json" >nul
        )
    )
)
echo Done applying FFlags!
pause
goto :eof

:remove_fflags
echo Removing ClientAppSettings.json from all detected Roblox versions...
for %%P in (%BOOTSTRAP_PATHS%) do (
    if exist "%%P" (
        for /d %%V in ("%%P\version-*") do (
            if exist "%%V\ClientSettings\ClientAppSettings.json" (
                del /f /q "%%V\ClientSettings\ClientAppSettings.json"
                echo Removed from %%V
            )
        )
    )
)
echo Done removing FFlags!
pause
goto :eof
