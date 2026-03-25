:: ----------------------------------------------------------------- 
:: Title: SetTcSysSrvToDisabled.cmd
:: Version: 1.0
:: Description: This script performs pre-restore operations such as
:: disabling the TwinCAT System Service and saving specific folders.
:: ----------------------------------------------------------------- 
@echo off
title Set TwinCAT System Service to 4 'disabled'
setlocal enabledelayedexpansion

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

:: Call the helper script to set the TwinCAT System Service to 4 'disabled'
call "%~dp0Helper\SetTcSysSrvTo.cmd" 4 %WindowsPartition%
if %ERRORLEVEL% equ 0 (
    echo TwinCAT System Service set to 4 'disabled' successfully.
) else (
    echo Failed to set TwinCAT System Service to 4 'disabled'.
    exit /b %ERRORLEVEL%
)

endlocal
exit /b 0