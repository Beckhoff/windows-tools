# ConfigureBasicSystem

There are some basic settings that are useful to get started with a Beckhoff Windows System quickly. We provide sample scripts for the following settings:  

##  TwinCAT  

•   Start TwinCAT in Run mode on boot    
•   Activate core isolation 
•   Add ADS Route  
•   Change AMS Net Id  
•   Install EtherCAT Driver with TwinCAT RTE Install    

## TwinCAT configuration  
  
Start TwinCAT in Run mode on boot:  
```
# Check os architecture
if ([System.Environment]::Is64BitProcess) {
$RegPath = "HKLM:\SOFTWARE\WOW6432Node\Beckhoff\TwinCAT3\System"
} 
else {
$RegPath = "HKLM:\SOFTWARE\Beckhoff\TwinCAT3\System"
}

# Set reg key
Set-ItemProperty $RegPath "SysStartupState" -Value 5 -type DWord -PassThru
```

Activate core isolation:  
```
$logicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
$logicalProcessorsNew = $logicalProcessors - 1
Start-Process -Wait -WindowStyle Hidden -FilePath "bcdedit" -ArgumentList "/set numproc $logicalProcessorsNew"
```
Add ADS Route:
```
# Location of routes file
$routesPath = "C:\TwinCAT\3.1\Target"
$routesFile = "StaticRoutes.xml"

# Create a new Route Element
$xmlfile = [xml](Get-Content "$routesPath\$routesFile")
$new_route_node =$xmlfile.SelectSingleNode("//TcConfig/RemoteConnections")

$new_route_node.AppendChild($xmlfile.CreateElement("Route"))|out-null
$new_route_node = $xmlfile.SelectSingleNode("//TcConfig/RemoteConnections/Route")

# Add a new name "RemoteSystem123" for the route
$new_name_node = $new_route_node.AppendChild($xmlfile.CreateElement("Name"))
$new_name_node.AppendChild($xmlfile.CreateTextNode("RemoteSystem123")) | Out-Null

# Add address "192.168.1.75" for the route
$new_address_node = $new_route_node.AppendChild($xmlfile.CreateElement("Address"))
$new_address_node.AppendChild($xmlfile.CreateTextNode("192.168.1.75")) | Out-Null

# Add NetId "192.168.1.75.1.1" for the route
$new_netid_node = $new_route_node.AppendChild($xmlfile.CreateElement("NetId"))
$new_netid_node.AppendChild($xmlfile.CreateTextNode("192.168.1.75.1.1")) | Out-Null

# Add a route type
$new_type_node = $new_route_node.AppendChild($xmlfile.CreateElement("Type"))
$new_type_node.AppendChild($xmlfile.CreateTextNode("TCP_IP")) | Out-Null

# Add route flags
$new_flags_node = $new_route_node.AppendChild($xmlfile.CreateElement("Flags"))
$new_flags_node.AppendChild($xmlfile.CreateTextNode("64")) | Out-Null

# Save the new route
$xmlfile.save("$routesPath\$routesFile")
```
Change AMS Net Id:  
```
#IP Address (Used to change the AMS Net ID)
$ipAddr = "192.168.1.5"

$regKeyWow6432 = "HKLM:\SOFTWARE\WOW6432Node\"
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
}
```
Install EtherCAT Driver with TwinCAT RTE Install:  
```
$adapter_name = "Ethernet1"

# Install driver for adapter
Start-Process -Wait C:\TwinCAT\3.1\System\TcRteInstall.exe -ArgumentList "-installnic $adapter_name /S" -PassThru
```


