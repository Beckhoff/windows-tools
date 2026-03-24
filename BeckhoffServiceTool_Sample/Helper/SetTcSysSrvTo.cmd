:: ----------------------------------------------------------------- 
:: Title: SetTcSysSrvTo.cmd
:: Version: 1.0
:: Description: This script sets the TwinCAT System Service start type.
:: ----------------------------------------------------------------- 
@echo off
Title Set TwinCAT System Service Start Type
setlocal enabledelayedexpansion

set StartType=%~1
set WindowsPartition=%~2
set "Hive=%WindowsPartition%\Windows\System32\config\SYSTEM"

:: Validate start type argument
if "%StartType%"=="" (
    echo No start type provided. Usage: SetTcSysSrvTo.cmd [StartType]
    echo StartType values: 2 'Automatic', 3 'Manual', 4 'Disabled'
    exit /b 1
) else (
    echo Setting TwinCAT System Service start type to %StartType%.
)

:: Validate Windows partition argument
if "%WindowsPartition%"=="" (
    echo No Windows partition provided. Usage: SetTcSysSrvTo.cmd [StartType] [WindowsPartition]
    exit /b 1
)

:: Load the SYSTEM hive to modify the service start type
call :RegLoad HKLM\TempSys "%Hive%"
reg add "HKLM\TempSys\ControlSet001\Services\TcSysSrv" /v Start /t REG_DWORD /d %StartType% /f >nul 2>&1
call :RegUnload HKLM\TempSys

endlocal
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