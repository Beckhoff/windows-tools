############################
## Install RTE Driver to all supported network adapters
############################

# TwinCAT version
$TwinCATVersion = 4026

# Path to the TwinCAT installer executable (adjust if needed)
if ($TwinCATVersion -eq 4026) { $installerPath = "C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\System\TcRteInstall.exe"}
else { $installerPath = "C:\TwinCAT\3.1\System\TcRteInstall.exe"}



# Driver folder containing the .inf files
if ($TwinCATVersion -eq 4026) { $driverFolder = "C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Driver\System"}
else { $driverFolder = "C:\TwinCAT\3.1\Driver\System"}


# Collect all supported Intel Device IDs from .inf files
$supportedDeviceIDs = @()

Get-ChildItem -Path $driverFolder -Filter *.inf -ErrorAction SilentlyContinue | ForEach-Object {
    $filePath = $_.FullName
    Write-Host "Parsing INF file: $($_.Name)"
    
    Get-Content -Path $filePath | ForEach-Object {
        $line = $_.Trim()
        
        # Skip empty lines and comments (lines starting with ;)
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith(';')) { 
            return 
        }
        
        # Match PCI\VEN_8086&DEV_XXXX (case-insensitive, capture 4 hex digits)
        if ($line -match 'PCI\\VEN_8086\&DEV_([0-9A-Fa-f]{4})') {
            $devID = $matches[1].ToUpper()
            if ($devID -notin $supportedDeviceIDs) {
                $supportedDeviceIDs += $devID
            }
        }
    }
}

# Check if supported devices found
if ($supportedDeviceIDs.Count -eq 0) {
    Write-Host "No supported Device IDs found in .inf files in $driverFolder. Check the path."
} 
else {
	
	Write-Host "Found $($supportedDeviceIDs.Count) supported Intel Device IDs from .inf files."

	# Build regex pattern for matching any supported Device ID
	$devPattern = 'PCI\\VEN_8086\&DEV_(' + ($supportedDeviceIDs -join '|') + ')'

	# Get all network adapters (add -IncludeHidden for virtual/hidden ones)
	$adapters = Get-NetAdapter  # Add -Physical to exclude virtual adapters if desired

	# Filter for compatible adapters (Intel + Device ID in supported list)
	$compatibleAdapters = $adapters | Where-Object {
		$hardwareIds = (Get-PnpDeviceProperty -InstanceId $_.PNPDeviceID -KeyName DEVPKEY_Device_HardwareIds).Data
		$hardwareIds | Where-Object { $_ -match $devPattern }
	}

	if ($compatibleAdapters.Count -eq 0) {
		Write-Host "No compatible network adapters found on this system (based on .inf files)."
	}
	else {
		# Install driver on each compatible adapter
		foreach ($adapter in $compatibleAdapters) {
			$adapterName = $adapter.Name
			Write-Host "Installing TwinCAT RTE driver for compatible adapter: $adapterName ($($adapter.InterfaceDescription))"
			
			Start-Process -Wait -FilePath $installerPath `
				-ArgumentList "-installnic `"$adapterName`" /S" -PassThru | Out-Null
		}

		Write-Host "Installation completed for all compatible adapters."
	}
}

############################