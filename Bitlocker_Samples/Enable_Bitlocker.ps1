# Bitlocker Sample Script
# Version 0.5

#
# Write-Log function
#
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Info','Warning','Error')]
        [string]$Severity,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )
 
    [pscustomobject]@{
        Time = (Get-Date -Format "yyyy-MM-dd HH:mm")
        Severity = $Severity
        Message = $Message
    } | Export-Csv -Path "$env:Temp\LogFile.csv" -Append -NoTypeInformation
 }

#
# Variables declaration
#
$FirmwareType = $env:firmware_type
$OSArchitecture = (Get-CimInstance -ClassName CIM_OperatingSystem).OSArchitecture 
$OSReleaseId = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$TPMPresent = [bool](Get-WmiObject -class WIN32_TPM -Namespace root\CIMv2\Security\Microsofttpm).IsEnabled_InitialValue
$TPMReady = [bool](Get-WmiObject -class WIN32_TPM -Namespace root\CIMv2\Security\Microsofttpm).IsActivated_InitialValue
$BitLockerReadyDrive = (Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction SilentlyContinue).MountPoint 
$BitLockerDecrypted = (Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction SilentlyContinue).VolumeStatus
$KeyProtectorLocation = "C:\Users\Administrator\Desktop\KeyProtector.txt"
$TwinCATSysService = (Get-Service -Name TcSysSrv -ErrorAction SilentlyContinue).Status

#
# Define exit codes
#
$Error_Success = 0
$Error_OsLegacy = 10
$Error_Os32Bit = 11
$Error_OsReleaseId = 12
$Error_TpmNotPreent = 20
$Error_TpmNotReady = 21
$Error_BLDriveNotReady = 30
$Error_BLEncryptionInProgress = 31
$Error_BLDecryptionInProgress = 32
$Error_BLFullyEncrypted = 32
$Error_TcSysPsExtensionMissing = 40
$Error_TcSysStateRunning = 41

#
# Check if TwinCAT system service is available and running
# Import TwinCAT AdsApi powershell module
# Check if TwinCAT is in CONFIG mode
#
if ($TwinCATSysService -eq "Running") 
{
    if ([bool](Test-Path HKLM:\SYSTEM\CurrentControlSet\Services\TcSysSrv\))
    {            
        $TCPowerShellExt = [System.IO.Path]::GetDirectoryName((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WOW6432Node\Beckhoff\TwinCAT3\" -Name "TwinCATDir") -replace '"')
        $TCPowerShellExt += '\AdsApi\Powershell\TcXaeMgmt\TcXaeMgmt.psd1'            
        if (Test-Path $TCPowerShellExt)
        {                
            Import-Module $TCPowerShellExt
            $TCSystemState = (Get-AdsState).State
            if ($TCSystemState -ne "Config")
            {
                Write-Host "TwinCAT is in RUN mode. Bitlocker can not be enabled."
                Write-Log -Message "TwinCAT is in RUN mode. Bitlocker can not be enabled." -Severity Error
                Exit $Error_TcSysStateRunning
            }
        } 
        else 
        {
            Write-Host "TwinCAT AdsApi powershell extension not found."
            Write-Log -Message "TwinCAT AdsApi powershell extension not found." -Severity Error
            Exit $Error_TcSysPsExtensionMissing            
        }
    }       
}

#
# Check if boot mode is UEFI or LEGACY
#
if ($FirmwareType -ne "UEFI")
{
    Write-Host "OS Boot Mode is LEGACY."
    Write-Host "TPM is not supported with this Boot Mode."
    Write-Log -Message "OS Boot Mode is LEGACY." -Severity Error
	Write-Log -Message "TPM is not supported with this Boot Mode." -Severity Error
	Exit $Error_OsLegacy
} else {
    Write-Host "OS boot mode is UEFI"
	Write-Log -Message "OS boot mode is UEFI" -Severity Info
}

#
# Check if architecture is 32 Bit or 64 Bit
#
if ($OSArchitecture -ne "64-bit")
{
    Write-Host "OS architecture is 32 bit"
    Write-Host "TPM is not supported with this OS architecture"
    Write-Log -Message "OS architecture is 32 bit" -Severity Error
	Write-Log -Message "TPM is not supported with this OS architecture" -Severity Error
	Exit $Error_Os32Bit
} else {
    Write-Host "OS architecture is 64 bit"
    Write-Log -Message "OS architecture is 64 bit" -Severity Info
}

#
# Check if OS release id is supported (below 1809 is not supported)
#
if ($OSReleaseId -lt '1809') 
{
    Write-Host "OS ReleaseId is lower than 1809 and will not be supported"
    Write-Log -Message "OS ReleaseId is lower than 1809 and will not be supported" -Severity Error
	Exit $Error_OsReleaseId
} else {
    Write-Host "OS ReleaseId is supported."
    Write-Log -Message "OS ReleaseId is supported." -Severity Info
}

#
# Check if TPMPresent is true
#
if (!$TPMPresent)
{
    Write-Host "TPM is not present. Please check the BIOS settings (Trusted Platform)"
    Write-Log -Message "TPM is not present. Please check the BIOS settings (Trusted Platform)" -Severity Error
	Exit $Error_TpmNotPreent    
} else {
    Write-Host "TPM is present"
    Write-Log -Message "TPM is present" -Severity Info
}

#
# Check if TPM is ready
#
if (!$TPMReady)
{
    Write-Host "TPM is not ready"
    Write-Log -Message "TPM is not ready" -Severity Error
	Exit $Error_TpmNotReady  
} else {
    Write-Host "TPM is ready"
    Write-Log -Message "TPM is ready" -Severity Info
}

#
# Check if MountPoint exists
#
if (!$BitLockerReadyDrive)
{
    Write-Host "Bitlocker MountPoint does not exist"
    Write-Log -Message "Bitlocker MountPoint does not exist" -Severity Error
    Exit $Error_BLDriveNotReady      
} else {
    Write-Host "Bitlocker MountPoint exists"
    Write-Log -Message "Bitlocker MountPoint exists" -Severity Info
}


#
# Check Bitlocker status states
#
switch ($BitLockerDecrypted)
{
"FullyDecrypted" {
	Write-Host "Bitlocker volume is fully decrypted"
	Write-Log -Message "Bitlocker volume is fully decrypted" -Severity Info}
"EncryptionInProgress" {
	Write-Host "Bitlocker volume encryption is in progress. Stopping at this point."
	Write-Log -Message "Bitlocker volume encryption is in progress. Stopping at this point." -Severity Error
	Exit $Error_BLEncryptionInProgress}
"DecryptionInProgress" {
	Write-Host "Bitlocker volume decryption is in progress. Stopping at this point"
	Write-Log -Message "Bitlocker volume decryption is in progress. Stopping at this point" -Severity Error
	Exit $Error_BLDecryptionInProgress}
"FullyEncrypted" {
	Write-Host "Bitlocker volume is already encrypted. Stopping at this point."
	Write-Log "Bitlocker volume is already encrypted. Stopping at this point."
	Exit $Error_BLFullyEncrypted}
}

#
# Add Bitlocker Protectors
#
Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -TpmProtector -ErrorAction SilentlyContinue
Write-Log -Message "Adding Bitlocker TpmProtector" -Severity Info
Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector -ErrorAction SilentlyContinue
Write-Log -Message "Adding Bitlocker RecoveryPasswordProtector" -Severity Info

#
# Initialize TPM, add recovery partition if needed and enable Bitlocker
#
Initialize-Tpm -AllowClear -AllowPhysicalPresence
BdeHdCfg -target $env:SystemDrive shrink -quiet
Enable-BitLocker -MountPoint $env:SystemDrive -RecoveryPasswordProtector -EncryptionMethod Aes256 -UsedSpaceOnly
Write-Log -Message "TPM initialized, recovery partition added if needed and Bitlocker enabled." -Severity Info

#
# Save Bitlocker KeyProtectors to defined target location
#
$KeyProtector = (Get-BitLockerVolume -MountPoint C).KeyProtector > $KeyProtectorLocation
Write-Host "Saved Keyprotector to" $KeyProtectorLocation
Write-Log -Message ("Saved Keyprotector to " + $KeyProtectorLocation) -Severity Info

#
# Finish
#
Write-Host
Write-Host "Bitlocker has been successfully enabled. Restart the system to start encryption."
Write-Log -Message "Bitlocker has been successfully enabled. Restart the system to start encryption." -Severity Info
Exit $Error_Success