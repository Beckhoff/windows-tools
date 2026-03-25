:: ----------------------------------------------------------------- 
:: Title: SetTcStartupTypeConfig.cmd
:: Version: 1.0
:: Description: This script sets the TwinCAT Startup State to Config Mode.
:: ----------------------------------------------------------------- 
@echo off
title Set TwinCAT Startup State to Config Mode

:: Get Windows partition letter via GetWindowsPartition.cmd and set it to variable WindowsPartition
call "%~dp0Helper\GetWindowsPartition.cmd"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to identify Windows partition.
    exit /b %ERRORLEVEL%
)
:: Validate Windows partition argument
if "%WindowsPartition%"=="" (
    echo No Windows partition found.
    exit /b 1
)

:: Call the helper script to set the TwinCAT Startup State to Config Mode
call "%~dp0Helper\SetTcSysStartupState.cmd" 15 %WindowsPartition%
if %ERRORLEVEL% equ 0 (
    echo TwinCAT Startup State set to 15 'Config Mode' successfully.
) else (
    echo Failed to set TwinCAT Startup State to 15 'Config Mode'.
    exit /b %ERRORLEVEL%
)

exit /b 0