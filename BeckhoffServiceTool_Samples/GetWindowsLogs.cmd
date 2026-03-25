:: ----------------------------------------------------------------- 
:: Title: GetWindowsLogs.cmd
:: Version: 1.0
:: Description: This script saves Windows logs for analysis
:: ----------------------------------------------------------------- 
@echo off
title Get Windows Logs

set "WindowsPartition="
set "LogsDestination="
set "BstImagesPartition="
set "ComputerName="

:: Get Windows partition letter via GetWindowsPartition.cmd and set it to variable WindowsPartition
call "%~dp0Helper\GetWindowsPartition.cmd"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to identify Windows partition.
    exit /b %ERRORLEVEL%
)
:: Validate Windows partition variable
if "%WindowsPartition%"=="" (
    echo Error: Windows partition not identified.
    exit /b 1
)
:: Get BST images letter via GetBstImagesPartition.cmd and set it to variable BstImagesPartition
call "%~dp0Helper\GetBstImagesPartition.cmd"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to identify BST Images partition.
    exit /b %ERRORLEVEL%
)
:: Validate BST Images partition variable
if "%BstImagesPartition%"=="" (
    echo Error: BST Images partition not identified.
    exit /b 1
)

:: Get computer name via GetWindowsComputerName.cmd and set it to variable ComputerName
call "%~dp0Helper\GetWindowsComputerName.cmd" %WindowsPartition%
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to retrieve computer name.
    exit /b %ERRORLEVEL%
)
if "%ComputerName%"=="" (
    echo Error: Computer name not identified.
    exit /b 1
)

:: Set logs destination path
set "LogsDestination=%BstImagesPartition%\Logs\%ComputerName%\"

:: Copy the folder to restore location. 
:: XCOPY source [destination]
:: /E Copies directories and subdirectories, including empty ones.
:: /H Copies hidden and system files also.
:: /I If destination does not exist and copying more than one file, assumes that destination must be a directory
:: /Y Suppresses prompting to confirm you want to overwrite an existing destination file.
xcopy "%WindowsPartition%\Windows\System32\winevt\Logs\Application.evtx" "%LogsDestination%\winevt\" /E /H /I /Y
xcopy "%WindowsPartition%\Windows\System32\winevt\Logs\System.evtx" "%LogsDestination%\winevt\" /E /H /I /Y
xcopy "%WindowsPartition%\Windows\Logs\CBS\CBS.log" "%LogsDestination%\CBS\" /E /H /I /Y
xcopy "%WindowsPartition%\Windows\Panther\*" "%LogsDestination%\Panther\" /E /H /I /Y

:: Final message
echo Windows logs have been successfully copied to %LogsDestination%.
exit /b 0