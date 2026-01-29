@echo off
:: AUTO-ELEVATION: Check and request Admin Rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:MENU
cls
echo ==========================================
echo       WINDOWS SYSTEM OPTIMIZER MENU
echo ==========================================
echo  1) Adjust for Best Performance
echo  2) Cleanup Temp Files ^& Optimize Disks (Original Code)
echo  3) Browser Cleanup (Chrome, Edge, Brave, Firefox)
echo  4) Exit
echo ==========================================
set /p user_choice="Select an option (1-4): "

if "%user_choice%"=="1" goto PERFORMANCE
if "%user_choice%"=="2" goto TEMP_OPTIMIZE
if "%user_choice%"=="3" goto BROWSER_MENU
if "%user_choice%"=="4" exit
goto MENU

:PERFORMANCE
echo.
echo [*] Setting Performance Options to "Best Performance"...
:: ปรับ Visual Effects เป็น Best Performance
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
:: ปรับแต่ง Animation และจังหวะตอบสนอง
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012028010000000 /f >nul 2>&1
echo [DONE] Adjusted for Best Performance.
pause
goto MENU

:TEMP_OPTIMIZE
echo ---------------------------------------------------------
echo 1. CLEANING TEMPORARY FILES
echo ---------------------------------------------------------

:: 1. Clean Temp Files (Skips files in use)
echo [*] Cleaning temporary files...

:: Deleting user temp files
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%i in ("%temp%\*") do rd /s /q "%%i" >nul 2>&1

:: Deleting Windows system temp files
del /s /f /q "%systemroot%\Temp\*.*" >nul 2>&1
for /d %%i in ("%systemroot%\Temp\*") do rd /s /q "%%i" >nul 2>&1
echo [DONE] Temp cleanup finished.

echo.
echo ---------------------------------------------------------
echo 2. OPTIMIZING ALL DRIVES
echo ---------------------------------------------------------

echo This may take a while depending on your drive size...
:: /C performs the operation on all volumes
:: /H runs the operation at normal priority (faster)
:: /U prints the progress on the screen
:: /V display insight details before and after

:: 2. Optimize all drives
echo [*] Optimizing all drives (SSD Trim / HDD Defrag)...
defrag /C /H /U /V

echo.
echo ==========================================
echo CLEAN TEMP AND OPTIMIZE COMPLETED SUCCESSFULLY
echo ==========================================
pause
goto MENU

:BROWSER_MENU
cls
echo ==========================================
echo           BROWSER CLEANUP MENU
echo ==========================================
echo  1) Google Chrome
echo  2) Microsoft Edge
echo  3) Brave Browser
echo  4) Mozilla Firefox
echo  5) Clean ALL Browsers
echo  6) Back to Main Menu
echo ==========================================
set /p br_choice="Select browser to clean (1-6): "

if "%br_choice%"=="1" set "target=chrome" & goto CLEAN_BR
if "%br_choice%"=="2" set "target=edge" & goto CLEAN_BR
if "%br_choice%"=="3" set "target=brave" & goto CLEAN_BR
if "%br_choice%"=="4" set "target=firefox" & goto CLEAN_BR
if "%br_choice%"=="5" set "target=all" & goto CLEAN_BR
if "%br_choice%"=="6" goto MENU
goto BROWSER_MENU

:CLEAN_BR
echo.
:: ปิดโปรเซส Browser
if "%target%"=="chrome" taskkill /F /IM chrome.exe /T >nul 2>&1
if "%target%"=="edge" taskkill /F /IM msedge.exe /T >nul 2>&1
if "%target%"=="brave" taskkill /F /IM brave.exe /T >nul 2>&1
if "%target%"=="firefox" taskkill /F /IM firefox.exe /T >nul 2>&1
if "%target%"=="all" (
    taskkill /F /IM chrome.exe /T >nul 2>&1
    taskkill /F /IM msedge.exe /T >nul 2>&1
    taskkill /F /IM brave.exe /T >nul 2>&1
    taskkill /F /IM firefox.exe /T >nul 2>&1
)

:: ขั้นตอนการลบ Cache และ History
if "%target%"=="chrome" (
    echo [*] Cleaning Google Chrome...
    del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History" >nul 2>&1
)
if "%target%"=="edge" (
    echo [*] Cleaning Microsoft Edge...
    del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History" >nul 2>&1
)
if "%target%"=="brave" (
    echo [*] Cleaning Brave Browser...
    del /q /s /f "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\History" >nul 2>&1
)
if "%target%"=="firefox" (
    echo [*] Cleaning Mozilla Firefox...
    for /d %%i in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        rd /s /q "%%i\cache2" >nul 2>&1
        del /q /s /f "%%i\places.sqlite" >nul 2>&1
    )
)
if "%target%"=="all" (
    echo [*] Cleaning All Browsers...
    del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache\*.*" >nul 2>&1
    del /q /s /f "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\History" >nul 2>&1
    for /d %%i in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        rd /s /q "%%i\cache2" >nul 2>&1
        del /q /s /f "%%i\places.sqlite" >nul 2>&1
    )
)

echo [DONE] Browser cleanup finished.
pause
goto BROWSER_MENU
