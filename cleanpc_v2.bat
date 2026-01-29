@echo off
:: AUTO-ELEVATION: Check and request Admin Rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

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
echo ALL TASKS COMPLETED SUCCESSFULLY
echo ==========================================

pause
