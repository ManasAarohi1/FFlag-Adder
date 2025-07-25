@echo off
:: Location of your custom ClientAppSettings.json
set SOURCE_JSON=ClientAppSettings.json

:: Path to the Roblox Versions folder
set ROBLOX_VERSIONS=%localappdata%\Roblox\Versions

:: Loop through each version folder
for /d %%V in ("%ROBLOX_VERSIONS%\version-*") do (
    echo Patching %%V ...
    mkdir "%%V\ClientSettings" >nul 2>&1
    copy /Y "%SOURCE_JSON%" "%%V\ClientSettings\ClientAppSettings.json" >nul
)

echo.
echo Done! All Roblox version folders have been updated with your FFlags.
pause
