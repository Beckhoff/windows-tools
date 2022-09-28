@echo off

Echo General Baseboard Information 
wmic baseboard list full
pause

Echo Installed Windows Updates
Wmic qfe list brief
pause

Echo OS Build
Wmic os get BuildNumber
pause

Echo Beckhoff Image Number
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v Image
pause

Echo Beckhoff Image Version
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v Version
pause

Echo EditionId
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v EditionId
pause

Echo Driver Package
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v DriverPackage
pause

Echo Get Computer Name
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v LastComputerName
pause

Echo Get MAC Adress
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v FirstMACId
pause