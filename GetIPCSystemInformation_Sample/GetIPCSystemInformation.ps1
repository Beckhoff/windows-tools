# General Baseboard Information
Write-Host "General Baseboard Information"
Get-WmiObject Win32_BaseBoard | Format-List *


# Installed Windows Updates
Write-Host "Installed Windows Updates"
Get-WmiObject Win32_QuickFixEngineering | Select-Object HotFixID, Description, InstalledOn


# OS Build
Write-Host "OS Build"
(Get-WmiObject Win32_OperatingSystem).BuildNumber


# Beckhoff Image Number
Write-Host "Beckhoff Image Number"
Get-ItemPropertyValue 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Image'


# Beckhoff Image Version
Write-Host "Beckhoff Image Version"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Version'



# EditionId
Write-Host "EditionId"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'EditionId'


# Driver Package
Write-Host "Driver Package"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'DriverPackage'


# Get Baseboard
Write-Host "Baseboard"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Platform'


# Get Computer Name
Write-Host "Computer Name"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'LastComputerName'


# Get MAC Address
Write-Host "MAC Address"
Get-WmiObject win32_networkadapterconfiguration | select description, macaddress


# Get Update Build Revision
Write-Host "Update Build Revision"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' 'UBR'

