###################################
## Disable Autologin Administrator
###################################

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

Set-ItemProperty $RegPath "AutoAdminLogon" -Value "0" -type String 

############################
