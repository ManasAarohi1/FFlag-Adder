@echo off
:: Location of your custom ClientAppSettings.json
set "SOURCE_JSON=ClientAppSettings.json"

:: Common base directories to scan for bootstrappers
set "SEARCH_DIRS=%localappdata%\Roblox"
set "SEARCH_DIRS=!SEARCH_DIRS!;%localappdata%\Bloxstrap"
set "SEARCH_DIRS=!SEARCH_DIRS!;%localappdata%\Fishstrap"
set "SEARCH_DIRS=!SEARCH_DIRS!;%localappdata%\Voidstrap"
set "SEARCH_DIRS=!SEARCH_DIRS!;%programfiles%\Roblox"
set "SEARCH_DIRS=!SEARCH_DIRS!;%programfiles(x86)%\Roblox"
set "SEARCH_DIRS=!SEARCH_DIRS!;%userprofile%\AppData\Roaming"

:MENU
cls
echo ==============================
echo   Roblox FFlag Manager
echo ==============================
echo 1. Apply FFlags from %SOURCE_JSON%
echo 2. Remove all FFlags
echo 3. Exit
echo ==============================
set /p choice="Choose an option (1-3): "

if "%choice%"=="1" goto APPLY
if "%choice%"=="2" goto REMOVE
if "%choice%"=="3" exit
goto MENU

:APPLY
cls
echo Scanning for Roblox bootstrapper Versions folders...
for %%D in (%SEARCH_DIRS%) do (
    if exist "%%~D\Versions" (
        for /d %%V in ("%%~D\Versions\version-*") do (
            echo Patching %%V ...
            mkdir "%%V\ClientSettings" >nul 2>&1
            copy /Y "%SOURCE_JSON%" "%%V\ClientSettings\ClientAppSettings.json" >nul
        )
    )
)
echo.
echo Done! All detected Roblox installations have been updated with your FFlags.
pause
goto MENU

:REMOVE
cls
echo Scanning for Roblox bootstrapper Versions folders...
for %%D in (%SEARCH_DIRS%) do (
    if exist "%%~D\Versions" (
        for /d %%V in ("%%~D\Versions\version-*") do (
            if exist "%%V\ClientSettings\ClientAppSettings.json" (
                del /f /q "%%V\ClientSettings\ClientAppSettings.json" >nul
                echo Removed from %%V
            )
        )
    )
)
echo.
echo Done! All FFlags have been removed from detected installations.
pause
