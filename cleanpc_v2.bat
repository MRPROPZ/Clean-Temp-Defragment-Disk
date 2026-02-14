@echo off
:: AUTO-ELEVATION: Check and request Admin Rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)
color E

:MENU
cls
echo ==========================================
echo       WINDOWS SYSTEM OPTIMIZER MENU
echo ==========================================
echo  1) Adjust for Best Performance
echo  2) Disk Cleanup ^& Cleanup Temp Files ^& Optimize Disks
echo  3) Browser Cleanup (Chrome, Edge, Brave, Firefox)
echo  4) Exit
echo ==========================================
choice /c 1234 /n /m "Select an option: "

if errorlevel 4 goto EXIT
if errorlevel 3 goto BROWSER_MENU
if errorlevel 2 goto CLEAN_PC
if errorlevel 1 goto PERFORMANCE
goto MENU

:PERFORMANCE
cls
echo [*] Setting Performance Options to "Best Performance"...
:: Adjust Visual Effects to Best Performance
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
:: Adjust Animation and responding
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012028010000000 /f >nul 2>&1
echo [DONE] Adjusted for Best Performance.
pause
goto MENU

:CLEAN_PC
cls
echo ---------------------------------------------------------
echo 1. DISK CLEANUP
echo ---------------------------------------------------------

:: Remove Temp Files Windows
echo remove temp on %TEMP% ...
del /s /q "%TEMP%\*.*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1

:: Remove Temp Files Windows (Must Run as Administrator)
echo remove temp on C:\Windows\Temp ...
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*.*") do rmdir "%%p" /s /q

:: Delete Recycle Bin
echo remove files in Recycle bin...
rd /s /q C:\$Recycle.Bin

:: Delete Windows Update Cache
echo remove Windows Update cache...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /s /q C:\Windows\SoftwareDistribution\Download\*.* >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1

:: Use CleanMgr Automatic
echo Using Disk Cleanup Tool...
cleanmgr /sagerun:1

echo ===============================================
echo Diskcleanup Disk C: Successfully!
echo ===============================================

echo.
echo ---------------------------------------------------------
echo 2. CLEANING TEMPORARY FILES
echo ---------------------------------------------------------

:: Clean Temp Files (Skips files in use)
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
echo 3. OPTIMIZING ALL DRIVES
echo ---------------------------------------------------------

echo This may take a while depending on your drive size...
:: /C performs the operation on all volumes
:: /H runs the operation at normal priority (faster)
:: /U prints the progress on the screen
:: /V display insight details before and after

:: Optimize all drives
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
choice /c 123456 /n /m "Select browser to clean (1-6): "

if errorlevel 6 goto MENU
if errorlevel 5 set "target=all" & goto CLEAN_BR
if errorlevel 4 set "target=firefox" & goto CLEAN_BR
if errorlevel 3 set "target=brave" & goto CLEAN_BR
if errorlevel 2 set "target=edge" & goto CLEAN_BR
if errorlevel 1 set "target=chrome" & goto CLEAN_BR
goto BROWSER_MENU

:CLEAN_BR
echo.
:: Close Process Browser
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

:: Process remove Cache & History
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

