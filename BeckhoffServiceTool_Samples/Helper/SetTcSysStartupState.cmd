:: ----------------------------------------------------------------- 
:: Title: SetTcSysStartupState.cmd
:: Version: 1.0
:: Description: This script sets the TwinCAT Startup State. 5 for Run Mode, 15 for Config Mode.
:: ----------------------------------------------------------------- 
@echo off

set "SysStartupState=%~1"
set "WindowsPartition=%~2"
set "SwHive=%WindowsPartition%\Windows\System32\config\SOFTWARE"

:: Validate startup state argument
if "%SysStartupState%"=="" (
    echo No startup state provided. Usage: SetTcSysStartupState.cmd [SysStartupState] [WindowsPartition]
    echo SysStartupState values: 5=Run Mode, 15=Config Mode
    exit /b 1
)

if "%SysStartupState%"=="5" goto :StartupStateValid
if "%SysStartupState%"=="15" goto :StartupStateValid

echo Invalid startup state: %SysStartupState%
echo SysStartupState values: 5=Run Mode, 15=Config Mode
exit /b 1

:StartupStateValid
echo Setting TwinCAT Startup State to %SysStartupState%.

:: Validate Windows partition argument
if "%WindowsPartition%"=="" (
    echo No Windows partition provided. Usage: SetTcSysStartupState.cmd [SysStartupState] [WindowsPartition]
    exit /b 1
)

call "%~dp0GetProcessorArchitecture.cmd" %WindowsPartition%
if %ERRORLEVEL% neq 0 (
    echo Failed to retrieve processor architecture from %WindowsPartition%.
    exit /b %ERRORLEVEL%
)
if /i "%ARCH%"=="AMD64" (
    set "TcRegPath=HKLM\TempSw\WOW6432Node\Beckhoff\TwinCAT3\System"
) else (
    if /i "%ARCH%"=="x86" (
        set "TcRegPath=HKLM\TempSw\Beckhoff\TwinCAT3\System"
    ) else (
        echo Unsupported architecture: %ARCH%
        exit /b 1
    )
)

:: Load the SOFTWARE hive to modify the TwinCAT startup state
call :RegLoad HKLM\TempSw "%SwHive%"
reg add "%TcRegPath%" /v SysStartupState /t REG_DWORD /d %SysStartupState% /f >nul 2>&1
call :RegUnload HKLM\TempSw

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