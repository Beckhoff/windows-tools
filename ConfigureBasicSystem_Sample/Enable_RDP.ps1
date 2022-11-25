############################
## Enable Remote Desktop 
############################

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

#############################
