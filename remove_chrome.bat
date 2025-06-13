@echo off
setlocal enabledelayedexpansion
title Google Chrome Complete Removal Script
color 0E

echo ================================
echo Google Chrome Complete Removal Script
echo ================================
echo.
echo This script will completely remove Google Chrome from your system.
echo It will:
echo - Stop Chrome processes
echo - Uninstall Chrome via Control Panel
echo - Remove Google Update Service
echo - Delete Chrome registry entries
echo - Remove Chrome program files
echo - Clean up remaining folders
echo.
echo WARNING: This will remove ALL Chrome data including bookmarks,
echo          passwords, and extensions (unless synced to Google account)
echo.
set /p confirm=Are you sure you want to continue? (Y/N): 
if /i not "%confirm%"=="Y" (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
echo Starting Chrome removal process...
echo.

REM Create backup folder with timestamp
set timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set backupdir=C:\ChromeRemoval_Backup_%timestamp%
mkdir "%backupdir%" 2>nul

echo [1/8] Stopping Chrome processes...
taskkill /f /im chrome.exe 2>nul
taskkill /f /im chromedriver.exe 2>nul
taskkill /f /im chrome_proxy.exe 2>nul
taskkill /f /im GoogleUpdate.exe 2>nul
taskkill /f /im GoogleCrashHandler.exe 2>nul
taskkill /f /im GoogleCrashHandler64.exe 2>nul
timeout /t 3 /nobreak >nul

echo [2/8] Attempting standard uninstall...
REM Try common Chrome uninstall paths directly with timeout
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    echo Found Chrome installation in Program Files - attempting uninstall...
    start /wait /b timeout /t 30 /nobreak >nul 2>&1 & "C:\Program Files\Google\Chrome\Application\chrome.exe" --uninstall --force-uninstall --system-level 2>nul
    timeout /t 5 /nobreak >nul
)

if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
    echo Found Chrome installation in Program Files x86 - attempting uninstall...
    start /wait /b timeout /t 30 /nobreak >nul 2>&1 & "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --uninstall --force-uninstall --system-level 2>nul
    timeout /t 5 /nobreak >nul
)

REM Kill any hanging uninstaller processes
taskkill /f /im "Installer.exe" 2>nul
taskkill /f /im "setup.exe" 2>nul
taskkill /f /im "GoogleChromeStandaloneEnterprise*.exe" 2>nul

echo Standard uninstall attempt completed, continuing with manual removal...

echo [3/8] Removing Google Update Service...
REM Stop Google Update services
net stop "Google Update Service (gupdate)" 2>nul
net stop "Google Update Service (gupdatem)" 2>nul
net stop "GoogleUpdaterService" 2>nul
net stop "GoogleUpdaterInternalService" 2>nul
net stop "Google Chrome Elevation Service" 2>nul

REM Delete Google Update services
sc delete "gupdate" 2>nul
sc delete "gupdatem" 2>nul
sc delete "GoogleUpdaterService" 2>nul
sc delete "GoogleUpdaterInternalService" 2>nul
sc delete "Google Chrome Elevation Service" 2>nul

REM Uninstall Google Update using its own uninstaller
if exist "C:\Program Files (x86)\Google\Update\GoogleUpdate.exe" (
    "C:\Program Files (x86)\Google\Update\GoogleUpdate.exe" -uninstall 2>nul
)
if exist "C:\Program Files\Google\Update\GoogleUpdate.exe" (
    "C:\Program Files\Google\Update\GoogleUpdate.exe" -uninstall 2>nul
)

echo [4/8] Backing up and removing registry entries...
REM Backup registry keys before deletion
reg export "HKLM\SOFTWARE\Google" "%backupdir%\HKLM_SOFTWARE_Google.reg" /y 2>nul
reg export "HKLM\SOFTWARE\WOW6432Node\Google" "%backupdir%\HKLM_SOFTWARE_WOW6432Node_Google.reg" /y 2>nul
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "%backupdir%\HKLM_Uninstall_Chrome.reg" /y 2>nul
reg export "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "%backupdir%\HKLM_WOW6432_Uninstall_Chrome.reg" /y 2>nul
reg export "HKLM\SOFTWARE\Policies\Google" "%backupdir%\HKLM_Policies_Google.reg" /y 2>nul
reg export "HKLM\SOFTWARE\WOW6432Node\Policies\Google" "%backupdir%\HKLM_WOW6432_Policies_Google.reg" /y 2>nul

REM Remove Google registry keys
reg delete "HKLM\SOFTWARE\Google" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Google" /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Google" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\Policies\Google" /f 2>nul

REM Remove Google Chrome file associations
reg delete "HKLM\SOFTWARE\RegisteredApplications" /v "Google Chrome" /f 2>nul
reg delete "HKLM\SOFTWARE\Classes\ChromeHTML" /f 2>nul
reg delete "HKLM\SOFTWARE\Classes\Applications\chrome.exe" /f 2>nul

echo [5/8] Removing program files...
REM Remove Chrome installation directories
if exist "C:\Program Files\Google\Chrome\" (
    echo Removing Chrome from Program Files...
    rd /s /q "C:\Program Files\Google\Chrome" 2>nul
)
if exist "C:\Program Files (x86)\Google\Chrome\" (
    echo Removing Chrome from Program Files x86...
    rd /s /q "C:\Program Files (x86)\Google\Chrome" 2>nul
)
if exist "C:\Program Files\Google\Update\" (
    echo Removing Google Update from Program Files...
    rd /s /q "C:\Program Files\Google\Update" 2>nul
)
if exist "C:\Program Files (x86)\Google\Update\" (
    echo Removing Google Update from Program Files x86...
    rd /s /q "C:\Program Files (x86)\Google\Update" 2>nul
)

REM Try to remove parent Google directories if empty
rd "C:\Program Files\Google" 2>nul
rd "C:\Program Files (x86)\Google" 2>nul

echo [6/8] Removing application data...
REM Remove Chrome data from ProgramData
if exist "C:\ProgramData\Google" (
    echo Removing C:\ProgramData\Google...
    rmdir /s /q "C:\ProgramData\Google" 2>nul
)

echo [7/8] Removing user profile data...
REM Remove Chrome user data for all users
for /d %%u in (C:\Users\*) do (
    if exist "%%u\AppData\Local\Google\Chrome" (
        echo Removing Chrome data for user: %%~nxu
        rmdir /s /q "%%u\AppData\Local\Google\Chrome" 2>nul
    )
    if exist "%%u\AppData\Roaming\Google\Chrome" (
        rmdir /s /q "%%u\AppData\Roaming\Google\Chrome" 2>nul
    )
    REM Try to remove parent Google directories if empty
    rmdir "%%u\AppData\Local\Google" 2>nul
    rmdir "%%u\AppData\Roaming\Google" 2>nul
)

echo [8/8] Cleaning up shortcuts and desktop icons...
REM Remove Chrome shortcuts
del "%PUBLIC%\Desktop\Google Chrome.lnk" 2>nul
del "%ALLUSERSPROFILE%\Desktop\Google Chrome.lnk" 2>nul
for /d %%u in (C:\Users\*) do (
    del "%%u\Desktop\Google Chrome.lnk" 2>nul
)

REM Remove from Start Menu
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome" (
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome" 2>nul
)
for /d %%u in (C:\Users\*) do (
    if exist "%%u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome" (
        rmdir /s /q "%%u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome" 2>nul
    )
)

REM Clean up temporary files
del /f /s /q "%TEMP%\chrome*" 2>nul
del /f /s /q "%TEMP%\Google*" 2>nul

echo.
echo ================================
echo Chrome removal completed!
echo ================================
echo.
echo Registry backups saved to: %backupdir%
echo.
echo What was removed:
echo - Chrome processes (terminated)
echo - Chrome installation files
echo - Google Update Service
echo - Chrome registry entries
echo - Chrome user data and profiles
echo - Chrome shortcuts and desktop icons
echo - Chrome temporary files
echo.
echo Note: If you had Chrome sync enabled, your bookmarks and settings
echo       are still saved in your Google account and will be restored
echo       when you reinstall Chrome and sign in.
echo.
echo You may need to restart your computer for all changes to take effect.
echo.
set /p restart=Would you like to restart now? (Y/N): 
if /i "%restart%"=="Y" (
    echo Restarting computer in 10 seconds...
    shutdown /r /t 10
) else (
    echo Please restart your computer manually when convenient.
)

pause