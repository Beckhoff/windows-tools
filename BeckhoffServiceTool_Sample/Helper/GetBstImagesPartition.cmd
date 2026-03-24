:: ----------------------------------------------------------------- 
:: Title: GetBstImagesPartition.cmd
:: Version: 1.0
:: Description: This script identifies the BST Images partition on the system
:: by enumerating all volumes and checking for the presence of the Windows directory.
:: -----------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

:: Create a temporary file for diskpart script
set "tempScript=%TEMP%\diskpart_script.txt"
echo list volume > "%tempScript%"

:: Run diskpart and parse output
for /f "skip=1 tokens=2,3,4*" %%a in ('diskpart /s "%tempScript%"') do (
    set "volume=%%a"
    set "label=%%c"
    set "letter=%%b"
    set "fs=%%d"
    set "type=%%e"
    set "size=%%f"
    set "status=%%g"
    set "info=%%h"
    
    :: Check if this volume has a drive letter
    if not "!letter!"=="" (
        if exist "!letter!:\Beckhoff Service Tool" (
            if exist "!letter!:\Images" (
                :: BST Images partition found
                goto :found
            )
        )
    )
)

:notfound
:: If we reach this point, no BST Images partition was found
echo BST Images partition not found.
del "%tempScript%" 2>nul
endlocal
exit /b 1

:found
:: Set the BST Images partition letter to the variable BstImagesPartition
del "%tempScript%" 2>nul
endlocal & set "BstImagesPartition=%letter%:"
exit /b 0