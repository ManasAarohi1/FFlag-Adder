@echo off
title FFlag Applier (Universal)
setlocal enabledelayedexpansion

:: === Path to the source JSON file ===
set "SOURCE_JSON=%~dp0IxpSettings.json"

if not exist "%SOURCE_JSON%" (
    echo [ERROR] IxpSettings.json not found in script directory.
    pause
    exit /b
)

:: === Build search paths ===
set "BOOTSTRAP_PATHS="
set "COMMON_DIRS=%localappdata%\Roblox\Versions;%localappdata%\Bloxstrap\Versions;%localappdata%\Fishstrap\Versions;%localappdata%\Voidstrap\Versions"

:: Add the common bootstrapper locations
for %%D in (%COMMON_DIRS%) do (
    if exist "%%~D" (
        set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%%~D"
    )
)

:: Also search %localappdata% and %appdata% for any folders containing version-* subfolders
for /d %%D in ("%localappdata%\*") do (
    for /d %%V in ("%%D\version-*") do (
        if exist "%%V" (
            set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%%D"
            goto :next_local
        )
    )
    :next_local
)
for /d %%D in ("%appdata%\*") do (
    for /d %%V in ("%%D\version-*") do (
        if exist "%%V" (
            set "BOOTSTRAP_PATHS=!BOOTSTRAP_PATHS!;%%D"
            goto :next_app
        )
    )
    :next_app
)

:: === Menu ===
echo =================================================
echo                FFlag Applier (Universal)
echo =================================================
echo   Press 1 to APPLY IxpSettings.json
echo   Press 2 to REMOVE all IxpSettings.json
echo =================================================
choice /C 12 /N /M "Choose: "

if errorlevel 2 goto remove_ixp
if errorlevel 1 goto apply_ixp

:apply_ixp
echo Applying IxpSettings.json to all detected Roblox versions...
for %%P in (%BOOTSTRAP_PATHS%) do (
    if exist "%%P" (
        for /d %%V in ("%%P\version-*") do (
            if exist "%%V" (
                echo Patching %%V ...
                mkdir "%%V\ClientSettings" >nul 2>&1
                copy /Y "%SOURCE_JSON%" "%%V\ClientSettings\IxpSettings.json" >nul
            )
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
