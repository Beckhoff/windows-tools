:: ----------------------------------------------------------------- 
:: Title: GetWindowsComputername.cmd
:: Version: 1.0
:: Description: This script get the computer name of the system and set it to variable ComputerName
:: ----------------------------------------------------------------- 
@echo off
title Get Windows Computer Name
setlocal enabledelayedexpansion

set "WindowsPartition=%1"
set "ComputerName="
set "CCS="
set "SysHive=%WindowsPartition%\Windows\System32\config\SYSTEM"

:: Validate Windows partition
if "%WindowsPartition%"=="" (
    echo Error: Windows partition not identified.
    exit /b 1
)

:: Get computer name from registry
call :RegLoad HKLM\TempSys "%SysHive%"

for /f "tokens=3" %%A in ('reg query HKLM\TempSys\Select /v Current ^| find "Current"') do set "CCS=%%A"
if "%CCS%"=="" (
    echo Failed to determine active ControlSet.
    call :RegUnload HKLM\TempSys
    exit /b 1
)
set /a CCS=%CCS%
set "CCS=00%CCS%"
set "CCS=%CCS:~-3%"

for /f "tokens=2*" %%A in ('reg query "HKLM\TempSys\ControlSet%CCS%\Control\ComputerName\ComputerName" /v ComputerName ^| find "REG_SZ"') do set "ComputerName=%%B"
if "%ComputerName%"=="" (
    echo Failed to query computer name from registry.
    call :RegUnload HKLM\TempSys
    exit /b 1
)

:: Unload the registry hive
call :RegUnload HKLM\TempSys

endlocal & set "ComputerName=%ComputerName%"
exit /b 0

:RegLoad
set KeyName=%~1
set HivePath=%~2
reg load %KeyName% %HivePath% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Failed to load registry hive %HivePath% to %KeyName%.
    exit /b 1
)
exit /b 0

:RegUnload
set KeyName=%~1
reg unload %KeyName% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Failed to unload registry hive %KeyName%.
    exit /b 1
)
exit /b 0