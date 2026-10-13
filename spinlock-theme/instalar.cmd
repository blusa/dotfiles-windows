@echo off
rem Instala el theme Spinlock NMR: screensaver SpinlockNMR.scr + fondos y colores (SpinlockNMR.deskthemepack).
rem Va dentro del zip que arma build.ps1, al lado de esos dos archivos.
setlocal
set "dst=%LOCALAPPDATA%\SpinlockNMR"
set "key=HKCU\Control Panel\Desktop"

if not exist "%dst%" mkdir "%dst%"
rem Si el screensaver esta corriendo (p. ej. la vista previa del panel) el archivo esta bloqueado
taskkill /f /im SpinlockNMR.scr >nul 2>&1
copy /y "%~dp0SpinlockNMR.scr" "%dst%\SpinlockNMR.scr" >nul || goto :error

rem Windows 11 ignora el screensaver de los .theme: se configura en el registro
reg add "%key%" /v SCRNSAVE.EXE /t REG_SZ /d "%dst%\SpinlockNMR.scr" /f >nul || goto :error
reg add "%key%" /v ScreenSaveActive /t REG_SZ /d 1 /f >nul
reg query "%key%" /v ScreenSaveTimeOut >nul 2>&1 || reg add "%key%" /v ScreenSaveTimeOut /t REG_SZ /d 900 /f >nul
rundll32.exe user32.dll,UpdatePerUserSystemParameters

rem Con Configuracion abierta el theme no se aplica
taskkill /f /im SystemSettings.exe >nul 2>&1
start "" "%~dp0SpinlockNMR.deskthemepack"
echo Listo: theme Spinlock NMR aplicado y screensaver en %dst%
exit /b 0

:error
echo No se pudo instalar el screensaver en %dst%
pause
exit /b 1
