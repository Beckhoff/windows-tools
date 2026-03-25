########################
## Configure Firewall 
########################

#Enable firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

#Close inbound and Outbound traffic
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Block –NotifyOnListen True

#Disable all current firewall rules
Get-NetFirewallRule | Set-NetFirewallRule -Enabled False

########################