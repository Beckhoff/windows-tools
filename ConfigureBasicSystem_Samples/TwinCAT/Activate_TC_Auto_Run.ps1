#####################################
## Activate TwinCAT Run Mode on Boot
#####################################

# Check os architecture
if ([System.Environment]::Is64BitProcess) {
$RegPath = "HKLM:\SOFTWARE\WOW6432Node\Beckhoff\TwinCAT3\System"
} 
else {
$RegPath = "HKLM:\SOFTWARE\Beckhoff\TwinCAT3\System"
}

# Set reg key
Set-ItemProperty $RegPath "SysStartupState" -Value 5 -type DWord -PassThru

############################