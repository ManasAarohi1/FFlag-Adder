@echo off
title FFlag Applier
setlocal enabledelayedexpansion

:: Path to your JSON file
set "SOURCE_JSON=%~dp0ClientAppSettings.json"

echo =================================================
echo             FFlag Applier
echo =================================================
echo Press 1 to APPLY FFlags
echo Press 2 to REMOVE all FFlags

choice /C 12 /N /M "Choose: "

if errorlevel 2 goto remove_fflags
if errorlevel 1 goto apply_fflags


:apply_fflags
echo Applying FFlags to Vanilla Roblox...
set "ROBLOX_FOUND=0"

:: Loop through Roblox version folders to find the active vanilla client
for /d %%D in ("%LOCALAPPDATA%\Roblox\Versions\*") do (
    if exist "%%D\RobloxPlayerBeta.exe" (
        set "ROBLOX_FOUND=1"
        echo Target found: %%D
        
        :: Create ClientSettings folder if it doesn't exist
        if not exist "%%D\ClientSettings" (
            mkdir "%%D\ClientSettings" >nul 2>&1
        )
        
        :: Copy the JSON to the correct vanilla location
        copy /Y "%SOURCE_JSON%" "%%D\ClientSettings\ClientAppSettings.json" >nul
        echo Done applying FFlags to this version!
    )
)

if "%ROBLOX_FOUND%"=="0" (
    echo Error: Could not find a valid Vanilla Roblox installation.
) else (
    echo All operations finished!
)
pause
goto :eof


:remove_fflags
echo Removing FFlags from Vanilla Roblox...
set "ROBLOX_FOUND=0"

for /d %%D in ("%LOCALAPPDATA%\Roblox\Versions\*") do (
    if exist "%%D\RobloxPlayerBeta.exe" (
        set "ROBLOX_FOUND=1"
        if exist "%%D\ClientSettings\ClientAppSettings.json" (
            del /f /q "%%D\ClientSettings\ClientAppSettings.json"
            echo Removed ClientAppSettings.json from %%D
        ) else (
            echo No ClientAppSettings.json found in %%D to remove.
        )
    )
)

if "%ROBLOX_FOUND%"=="0" (
    echo Error: Could not find a valid Vanilla Roblox installation.
) else (
    echo All operations finished!
)
pause
goto :eof
