############################
## Change AMS Net ID
############################

#IP Address (Used to change the AMS Net ID)
$ipAddr = "192.168.1.5"

# Check os architecture
if ([System.Environment]::Is64BitProcess) {
	$regKeyWow6432 = "HKLM:\SOFTWARE\WOW6432Node\"
	} 
	else {
	$regKeyWow6432 = "HKLM:\SOFTWARE\"
	}

# Create registry path
$regKeyBeckhoff = $regKeyWow6432 + "Beckhoff\"
$regKeyTc = $regKeyBeckhoff + "TwinCAT3\"
$regKeyTcSystem = $regKeyTc + "System"
$regKeyPropertyAmsNetId = "AmsNetId"

# Check if Beckhoff RegKey exists (does not exist on systems without TwinCAT)
if (Test-Path $regKeyTcSystem) {
	# Reading current AmsNetId from Windows Registry
	$amsNetId = Get-ItemProperty -Path $regKeyTcSystem -Name $regKeyPropertyAmsNetId

	# Using the IP address
	$ipAddrArr = $ipAddr.Split(".")

	# Stopping TwinCAT System Service and all dependencies
	Stop-Service -Name "TcSysSrv" -Force

	# Setting new AMS Net ID based on local IP address, the last two bytes from old AMS Net ID are kept
	$amsNetId.AmsNetId[0] = $ipAddrArr[0]
	$amsNetId.AmsNetId[1] = $ipAddrArr[1]
	$amsNetId.AmsNetId[2] = $ipAddrArr[2]
	$amsNetId.AmsNetId[3] = $ipAddrArr[3]
	Set-ItemProperty -Path $regKeyTcSystem -Name $regKeyPropertyAmsNetId -Value $amsNetId.AmsNetId

	# Starting TwinCAT System Service
	Start-Service -Name "TcSysSrv"

    # Retsart system
    Write-Host "Press ENTER to continue and restart the system. Otherwise just clone this window."
    Read-Host
    Restart-Computer

}

############################