############################
## Open Firewall Ports
############################

# Allow ADS (TCP) (port 48898)
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

# Allow ADS (TCP) (port 48899)
New-NetFirewallRule -DisplayName 'TwinCAT ADS (UDP)' `
                    -Profile @('Domain', 'Private') `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol UDP `
                    -LocalPort 48899

New-NetFirewallRule -DisplayName 'TwinCAT ADS (UDP)' `
                    -Profile @('Domain', 'Private') `
                    -Direction Outbound `
                    -Action Allow `
                    -Protocol UDP `
                    -LocalPort 48899
                                         
###################################