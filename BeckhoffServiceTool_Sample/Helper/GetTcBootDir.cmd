:: ----------------------------------------------------------------- 
:: Title: GetTcBootPath.cmd
:: Version: 1.0
:: Description: This script retrieves the TwinCAT boot dir and sets it to variable TwinCATBootDir. 
:: ----------------------------------------------------------------- 
@echo off
setlocal enabledelayedexpansion

set "WindowsPartition=%~1"
set "TcBootDir="
set "ARCH="
set "Hive=%WindowsPartition%\Windows\System32\config\SOFTWARE"

if "%WindowsPartition%"=="" (
    echo Error: Windows partition not identified.
    exit /b 1
)

call :RegLoad HKLM\TempSw "%Hive%"

call "%~dp0GetProcessorArchitecture.cmd" %WindowsPartition%

if /i "%ARCH%"=="AMD64" (
    set "TcRegPath=HKLM\TempSw\WOW6432Node\Beckhoff\TwinCAT3\3.1"
) else if /i "%ARCH%"=="x86" (
    set "TcRegPath=HKLM\TempSw\Beckhoff\TwinCAT3\3.1"
) else (
    echo Unsupported architecture: %ARCH%
    call :RegUnload HKLM\TempSw
    exit /b 1
)

reg query "%TcRegPath%" /v BootDir >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo TwinCAT registry key or BootDir value not found.
    call :RegUnload HKLM\TempSw
    exit /b %ERRORLEVEL%
)

for /f "tokens=2*" %%A in ('reg query "%TcRegPath%" /v BootDir ^| find "REG_SZ"') do (
    set "TcBootDir=!%%B!"
)

call :RegUnload HKLM\TempSw

endlocal & set "TwinCATBootDir=%TcBootDir%"
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