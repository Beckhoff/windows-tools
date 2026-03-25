:: ----------------------------------------------------------------- 
:: Title: RestoreTwinCATProject.cmd
:: Version: 1.0
:: Description: This script performs restore operations for a TwinCAT project
:: ----------------------------------------------------------------- 
@echo off
title Restore TwinCAT Project

set "WindowsPartition="
set "BstImagesPartition="
set "TwinCATBootDir="
set "ComputerName="

:: Get BST images letter via GetBSTImagesLetter.cmd and set it to variable BstImagesPartition
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
:: Get computer name via GetWindowsComputerName.cmd and set it to variable ComputerName
call "%~dp0Helper\GetWindowsComputerName.cmd" %WindowsPartition%
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to retrieve computer name.
    exit /b %ERRORLEVEL%
)
:: Get TwinCAT boot path via GetTcBootDir.cmd and set it to variable TwinCATBootDir
call "%~dp0Helper\GetTcBootDir.cmd" %WindowsPartition%
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to retrieve TwinCAT boot path.
    exit /b %ERRORLEVEL%
)

:: Validate variables computer name and TwinCAT boot path
if "%ComputerName%"=="" (
    echo Error: Computer name not identified.
    exit /b 1
)
if "%TwinCATBootDir%"=="" (
    echo Error: TwinCAT boot directory not identified.
    exit /b 1
)

:: Perform restore
set "Source=%BstImagesPartition%\Backup\%ComputerName%\Boot"
if not exist "%Source%" (
    echo Source folder %Source% does not exist. Cannot perform restore.
    exit /b 1
)
set "Destination=%WindowsPartition%%TwinCATBootDir%"
if not exist "%Destination%\" (
    mkdir "%Destination%" || (
        echo Error: Failed to create restore folder.
        exit /b 1
    )
)

:: Copy files and folders from source into restore location.
:: XCOPY source [destination    ]
:: /E Copies directories and subdirectories, including empty ones.
:: /H Copies hidden and system files also.
:: /I If destination does not exist and copying more than one file, assumes that destination must be a directory
:: /Y Suppresses prompting to confirm you want to overwrite an existing destination file.
xcopy "%Source%\*" "%Destination%" /E /H /I /Y
if %ERRORLEVEL% neq 0 (
    echo Error: Restore failed during file copy.
    exit /b %ERRORLEVEL%
)

:: Final message
echo Important data restored to %Destination%
exit /b 0