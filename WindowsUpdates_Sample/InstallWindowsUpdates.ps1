# Steps considered in this script are
    # UWF filter status
    # Volume free space
    # Windows Update Service    
    # Directory exist C:\WinUpdate\[SSU] \[MSU] \[.NET]
    # Windows Updates properly installed
    # Remove properly installed Windows Updates installation files C:\WinUpdate\[SSU] \[MSU] \[.NET]

    # 2021 LTSC and 2019 LTSC contain SSU (servicing stack update), 2016 LTSB needs separate SSU file
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Windows 10 IoT Enterprise 2021 LTSC                                                                                   |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Sample: windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu                                        |
        # | Already contains the SSU file                                                                                         |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | .\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64.cab               |
        # | .\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: WSUSSCAN.cab                                |
        # | .\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64-pkgProperties.txt |
        # | .\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64_uup.xml           |
        # | .\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: SSU-19041.4163-x64.cab                      |
        # +-----------------------------------------------------------------------------------------------------------------------+    

        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Windows 10 IoT Enterprise 2019 LTSC                                                                                   |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Sample: windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu                                        |
        # | Already contains the SSU file                                                                                         |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | .\windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu: ssu-17763.5568-x64.cab                      |
        # | .\windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu: Windows10.0-KB5035849-x64.cab               |
        # | .\windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu: Windows10.0-KB5035849-x64-pkgProperties.txt |
        # | .\windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu: Windows10.0-KB5035849-x64_uup.xml           |
        # | .\windows10.0-kb5035849-x64_eb960a140cd0ba04dd175df1b3268295295bfefa.msu: WSUSSCAN.cab                                |
        # +-----------------------------------------------------------------------------------------------------------------------+

        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Windows 10 IoT Enterprise 2016 LTSC                                                                                   |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | Sample: windows10.0-kb5035855-x86_202e177079c6c7fb6a503ad49a8abd07e8991676.msu                                        |
        # | Contains no SSU file                                                                                                  |
        # +-----------------------------------------------------------------------------------------------------------------------+
        # | .\windows10.0-kb5035855-x86_202e177079c6c7fb6a503ad49a8abd07e8991676.msu: WSUSSCAN.cab                                |
        # | .\windows10.0-kb5035855-x86_202e177079c6c7fb6a503ad49a8abd07e8991676.msu: Windows10.0-KB5035855-x86-pkgProperties.txt |
        # | .\windows10.0-kb5035855-x86_202e177079c6c7fb6a503ad49a8abd07e8991676.msu: Windows10.0-KB5035855-x86.xml               |
        # | .\windows10.0-kb5035855-x86_202e177079c6c7fb6a503ad49a8abd07e8991676.msu: Windows10.0-KB5035855-x86.cab               |        
        # +-----------------------------------------------------------------------------------------------------------------------+


function InstallUpdate {
    param(
        [string]$UpdatePath
    )

    if (-not (Test-Path $UpdatePath)) {
        Write-Host "FAIL: WindowsUpdateLocationDrive: $UpdatePath does not exist"
        return
    }

    $Component = ""
	switch -wildcard ($UpdatePath) {
    "*.NET*" { $Component = ".NET:"; break }
    "*SSU*"  { $Component = "SSU :"; break }
    "*MSU*"  { $Component = "MSU :"; break }
}

    $updates = Get-ChildItem $UpdatePath | Select-Object -ExpandProperty Name

    foreach ($updatename in $updates) {
        $HotfixID = $updatename.SubString(12, 9).ToUpper()
        $UpdateFullPath = Join-Path -Path $UpdatePath -ChildPath $updatename
        Write-Host "$Component Installing $updatename"
        $process = Start-Process -FilePath "wusa.exe" -ArgumentList "$UpdateFullPath /quiet /norestart" -Wait -PassThru -NoNewWindow        

        switch ($process.ExitCode) {
            3010 { 
                Write-Host "EXIT: Exit Code $($process.ExitCode) $HotfixID $updatename - Installation successful. Reboot required." }
            2359302 { 
                Write-Host "EXIT: Exit Code $($process.ExitCode) $HotfixID $updatename - Update already installed." }
            -2145124329 { 
                Write-Host "FAIL: Exit Code $($process.ExitCode) $HotfixID $updatename - Update is not applicable to this OS. Removing file." 
                Remove-Item -Path $UpdateFullPath -Force }
            87 { 
                Write-Host "FAIL: Exit Code $($process.ExitCode) $HotfixID $updatename - WUSA parameter not recognized or incorrect." 
                # Loop until the WUSA process exits
				# If an update does not support the "/norestart" parameter, it will immediately exit with code 87 but process "wusa.exe" is running and installing the update.
                while (Get-Process -Name "wusa" -ErrorAction SilentlyContinue) {
					Write-Host "INFO: Waiting for WUSA process to finish..."
					Start-Sleep -Seconds 5  # Adjust the sleep time as needed
                }
                Write-Host "INFO: WUSA process has finished."
                }
            }

        if ((Get-CimInstance -ClassName Win32_QuickFixEngineering).HotFixID -contains $HotfixID) {
            Write-Host "INFO: $HotfixID installed successfully"
            Write-Host "DEL : $UpdateFullPath will be removed"
            if (Test-Path $UpdateFullPath) {
				Remove-Item -Path $UpdateFullPath -Force
			}
        }
    }
}

# Definitions
$WindowsUpdateServiceName = "wuauserv"
$WindowsUpdateServiceStatus = Get-Service -Name $WindowsUpdateServiceName
$WindowsUpdateServiceStartType = $WindowsUpdateServiceStatus.StartType

# Update Paths
$WindowsUpdateLocationDrive = "C"
$WindowsUpdateSSUPath=$WindowsUpdateLocationDrive+":\WinUpdates\SSU"
$WindowsUpdateMSUPath=$WindowsUpdateLocationDrive+":\WinUpdates\MSU"
$WindowsUpdateNETPath=$WindowsUpdateLocationDrive+":\WinUpdates\.NET"

# Free Space
$VolumeFreeSpace = (Get-Volume -DriveLetter $WindowsUpdateLocationDrive).SizeRemaining
$VolumeMinFreeSpace = 10GB

# Error Codes
$ERR_SUCCESS = 0
$ERR_UWF = 1
$ERR_FREESPACE = 2
$ERR_WINUPDATESVC = 3

# Check UWF filter status
$NAMESPACE = "root\standardcimv2\embedded"
$UWFEnabled = (Get-WmiObject -Namespace $NAMESPACE -Class UWF_Filter).CurrentEnabled
if ($UWFEnabled) {
    Write-Host "WARN: Unified Write Filter is enabled. Unable to install updates."
    exit $ERR_UWF
} else {
    Write-Host "INFO: Unified Write Filter is not enabled."
}

# Check freespace available, at least 10 GB for Windows Update installation
if ($VolumeFreeSpace -lt $VolumeMinFreespace) {
    Write-Host "WARN: Not enough free space as recommended ($VolumeMinFreespace)."
    exit $ERR_FREESPACE
} else {
    Write-Host "INFO: Free space available: $VolumeFreeSpace Bytes"
}

# Check Windows Update Service Status, if not running start the service
$WindowsUpdateServiceStatus = Get-Service -Name $WindowsUpdateServiceName

if ($WindowsUpdateServiceStatus.StartType -eq "Disabled") {
    Write-Host "INFO: Windows Update Service is disabled."
    Set-Service -Name $WindowsUpdateServiceName -StartupType Automatic
    $DisabledWindowsUpdateServiceStatus = $true
}

if ($WindowsUpdateServiceStatus.Status -ne "Running") {
    Write-Host "INFO: Windows Update Service is $($WindowsUpdateServiceStatus.Status)."
    Start-Service $WindowsUpdateServiceName -ErrorAction SilentlyContinue
    $WindowsUpdateServiceStatus.WaitForStatus("Running", [timespan]::FromSeconds(10))
    if ($WindowsUpdateServiceStatus.Status -eq "Running") {
        Write-Host "INFO: Windows Update Service is started."
    } else {
        Write-Host "ERR : Failed to start Windows Update Service."
        exit $ERR_WINUPDATESVC
    }
} else {
    Write-Host "INFO: Windows Update Service is already started."
}

# Check if directory exist (\WinUpdate\) SSU / MSU / .NET and install existing updates
InstallUpdate($WindowsUpdateSSUPath)
InstallUpdate($WindowsUpdateMSUPath)
InstallUpdate($WindowsUpdateNETPath)

# Set Windows Update Service to its origin state if disabled
if ($DisabledWindowsUpdateServiceStatus -eq $true) {
    Write-Host "INFO: Windows Update Service set to its original state (disabled)."
    Set-Service -Name $ServiceName -StartupType Disabled
    Stop-Service -Name $ServiceName -Force
}