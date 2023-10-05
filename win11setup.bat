@echo off
powershell.exe -ExecutionPolicy Bypass -File "win11setup.ps1"

rem restart the computer

echo You need to restart the computer for some of the updates to take effect.
echo Do you want to restart the computer? (Y/N)
choice /c yn /n /m "Press Y for Yes, N for No: "

if errorlevel 2 goto NoRestart
if errorlevel 1 goto Restart

:Restart
shutdown /r /f /t 0
goto End

:NoRestart
echo Restart canceled. The computer will not be restarted.

:End
