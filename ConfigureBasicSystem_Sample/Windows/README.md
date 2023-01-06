# ConfigureBasicSystem

There are some basic settings that are useful to get started with a Beckhoff Windows System quickly. We provide sample scripts for the following settings:  

•   Create administrator and user accounts  
•	Set administrator and user password  
•   Enable or disable auto login  
•	Configure Firewall (turn on, disable rules, block traffic)  
•   Enable or disable RDP  
•	Open Firewall ports 


## Create user accounts, set Passwords and configure auto login  

Create new Administrator account with name "SystemAdministrator":
```
$username = "SystemAdministrator"
$password = "adminpw"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
if (-not ($null -eq $account)) {
    Remove-LocalUser -Name $username
}
New-LocalUser -Name $username -FullName $username -Description "System Administrator" -Password $passwordSec

# Make the user part of the Administrators Group
Add-LocalGroupMember -Group "Administrators" -Member $username
```
Change Administrator Password:  
```
$username = "SystemAdministrator"
$password = "TwinCAT123"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
# Change Password if User Exists
if (-not ($null -eq $account)) {
    $account = Get-LocalUser -Name $username
    $account | Set-LocalUser -Password $passwordSec
}
else {
    Write-Host "User named $username does not exist"
}
```  
Create unprivileged user account with name "TwinCAT_User"   

```
$username = "TwinCAT_User"
$password = "userpw"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
if (-not ($null -eq $account)) {
    Remove-LocalUser -Name $username
}
New-LocalUser -Name $username -FullName $username -Description "Standard Windows user" -Password $passwordSec

# Make the user part of the Administrators Group
Add-LocalGroupMember -Group "Users" -Member $username
```
Enable Autologin
```
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = "SystemAdministrator"
$DefaultPassword = "adminpw"

Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
```

Disable auto login:  

```
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

Set-ItemProperty $RegPath "AutoAdminLogon" -Value "0" -type String 
```  

## Configure Firewall
Configure and turn on firewall:
```
#Enable firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

#Close inbound and Outbound traffic
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Block –NotifyOnListen True

#Disable all current firewall rules
Get-NetFirewallRule | Set-NetFirewallRule -Enabled False
```
Open firewall ports:
```
#Allow ADS (TCP) (port 48898)
New-NetFirewallRule -DisplayName 'TwinCAT ADS (TCP)' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 48898

New-NetFirewallRule -DisplayName 'TwinCAT ADS (TCP)' `
                    -Profile @('Domain', 'Private') `
                    -Direction Outbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 48898                     
                                        
```

Enable RDP:  
```
# Enable RDP in Registry
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

# Allow RDP TCP-In (port 3389)
if($(Get-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)'))
{
    Set-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)' -Enabled True
}
else
{
    New-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)' `
                    -Profile Any `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort 3389
}
```
Disable RDP:  
```
# Disable RDP in Registry
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 1

# Block RDP TCP-In (port 3389)
if($(Get-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)'))
{
    Set-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)' -Enabled False
}
else
{
    New-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)' `
                    -Profile Any `
                    -Direction Inbound `
                    -Action Block `
                    -Protocol TCP `
                    -LocalPort 3389
}
```