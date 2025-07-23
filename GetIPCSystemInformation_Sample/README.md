# GetIPCSystemInformation
Running the following commands will help you to gather system information using WMI and Registry query.
The Sample script contains all commands explained in this file.

## Using WMI
Running the following commands will help you to gather system information using WMI.

#### 1.	General Baseboard Information:

```
Get-WmiObject Win32_BaseBoard | Format-List *
```

Output is for example:  
```
Product: CB7476  
Version: G2
```

#### 2.	Installed Windows Updates:

You can get a brief overview of the installed updates in the command line via the following command:

```
Get-WmiObject Win32_QuickFixEngineering | Select-Object HotFixID, Description, InstalledOn
```

to get a complete overview of all updates and their information (e.g. description, caption, etc.).

#### 3.	OS Build:

```
(Get-WmiObject Win32_OperatingSystem).BuildNumber
```

Output is:  
```
26100
```

## 2.2.	Using Registry

With the help of PowerShell, information about the image can be read out easily. For example, all keys and values under a registry key can be read out as follows:
```
Get-ItemProperty [-Path] [-Name]
```
And the value of a specific key as follows:
```
Get-ItemPropertyValue [-Path] [-Name]
```

Image and device information in Beckhoff Images can be found at:
```
HKLM\SOFTWARE\Beckhoff\IPC
```

#### 1.	Image Version:
**Get image:**  
```
Get-ItemPropertyValue 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Image'
```

Output is for example:
```  
IN-1211-0712-11-1
```

**Get version:**  
```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Version'
```

Output is for example:  
```
2025-12-00051
```

**Get edition:**  
```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'EditionId'
```

Output is for example:  
``` 
2024 LTSC
``` 
#### 2.	Driver Package
**Get driver package:**  

```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'DriverPackage'
```

Output is for example:  
```
8.11.6.0
```

#### 3.	Baseboard:
**Get baseboard:**  
```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'Platform'
```

Output is for example:  
```
CB7476
```

#### 4.	Device information:
**Get computer name:**  
```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Beckhoff\IPC' 'LastComputerName'
```

Output is for example:  
```
CP-XXXXXX
```

**Get MAC:**  
```
Get-WmiObject win32_networkadapterconfiguration | select description, macaddress
```

Output is for example:  
```
Intel(R) Ethernet Controller I226-IT      00:01:05:XX:XX:XX
```

#### 5.	OS Update Build Revision
**Get Update Build Revision:**  
```
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' 'UBR'
```

Output is for example: 
``` 
4351
```
