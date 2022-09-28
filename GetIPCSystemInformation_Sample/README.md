# GetIPCSystemInformation
Running the following commands will help you to gather system information using WMI and Registry query.
The Sample script contains all commands explained in this file.

## Using WMI
Running the following commands will help you to gather system information using WMI.

#### 1.	General Baseboard Information:

```
Wmic baseboard
```

Output is for example:
-	Product: CB6464
-	Version: G3


#### 2.	Installed Windows Updates:

You can get a brief overview of the installed updates in the command line via the following command:

```
Wmic qfe list brief
```
or
```
Wmic qfe list 
```

to get a complete overview of all updates and their information (e.g. description, caption, etc.).

#### 3.	OS Build:

```
Wmic os get BuildNumber
```

Output is:
Buildnumber
14393

## 2.2.	Using Registry

With the help of the CMD, information about the image can be read out easily. For example, all keys and values under a registry key can be read out as follows:
```
reg query <keyname> <valuename> /v
```
And the value of a specific key as follows:
```
reg query <keyname> /s
```

Image and device information in Beckhoff Images can be found at:
**HKLM\SOFTWARE\Beckhoff\IPC**


#### 1.	Image Version:
Get image:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v Image
```

Output is for example:
Image			REG_SZ	IN-0406-0112-02-1

Get version:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v Version
```

Output is for example:
Version		REG_SZ	2020-20-0001U

Get edition:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v EditionId
```

Output is for example:
EditionId		REG_SZ	2016 LTSB

#### 2.	Driver Package
Get driver package:

```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v DriverPackage
```

Output is for example:
Driverpackage 	REG_SZ	3.1.8

#### 3.	Baseboard:
Get baseboard:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v platform
```

Output is for example:
Platform 		REG_SZ	CB3064

4.	Device information:
Get computer name:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v LastComputerName
```

Output is for example:
LastComputerName 		REG_SZ	CP-XXXXXX

Get MAC:
```
Reg query HKLM\SOFTWARE\Beckhoff\IPC /v FirstMACId
```

Output is for example:
LastComputerName 		REG_BINARY	0000105xxxxxx

5.	OS Update Build Revision
Get Update Build Revision in hex:
```
Reg query “HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion” /v UBR 
```

Output is for example:
LastComputerName 		REG_DWORD	0xea6
