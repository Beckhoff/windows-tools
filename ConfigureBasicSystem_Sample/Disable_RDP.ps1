############################
## Disable Remote Desktop
############################

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

#############################
