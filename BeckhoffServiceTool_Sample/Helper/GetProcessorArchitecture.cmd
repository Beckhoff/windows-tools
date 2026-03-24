:: ----------------------------------------------------------------- 
:: Title: GetProcessorArchitecture.cmd
:: Version: 1.0
:: Description: This script retrieves the processor architecture of the system and sets it to variable ARCH.
:: ----------------------------------------------------------------- 
@echo off
title Get Processor Architecture
setlocal enabledelayedexpansion

set "WindowsPartition=%~1"
set "SysHive=%WindowsPartition%\Windows\System32\config\SYSTEM"

:: Validate Windows partition
if "%WindowsPartition%"=="" (
    echo Error: Windows partition not identified.
    exit /b 1
)

:: Load the SYSTEM hive to read the processor architecture
call :RegLoad HKLM\TempSys "%SysHive%"
if %ERRORLEVEL% neq 0 (
    exit /b %ERRORLEVEL%
)

for /f "tokens=3" %%A in ('reg query HKLM\TempSys\Select /v Current ^| find "Current"') do set "CCS=%%A"
if "%CCS%"=="" (
    echo Failed to detect active ControlSet.
    call :RegUnload HKLM\TempSys >nul 2>&1
    exit /b 1
)
set /a CCS=%CCS%
set "CCS=00%CCS%"
set "CCS=%CCS:~-3%"

for /f "tokens=2*" %%A in ('reg query "HKLM\TempSys\ControlSet%CCS%\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE ^| find "REG_SZ"') do (
    set "ARCH=%%B"
)

if "%ARCH%"=="" (
    echo Failed to retrieve PROCESSOR_ARCHITECTURE from offline registry.
    call :RegUnload HKLM\TempSys >nul 2>&1
    exit /b 1
)

:: Unload the SYSTEM hive
call :RegUnload HKLM\TempSys

if /i "%ARCH%"=="AMD64" echo Detected architecture: AMD64
if /i "%ARCH%"=="x86" echo Detected architecture: x86

endlocal & set "ARCH=%ARCH%"
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