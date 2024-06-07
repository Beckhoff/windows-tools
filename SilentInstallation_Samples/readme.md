# Silent Installation Parameters for TwinCAT 3.1 Build 4024 (XAE/XAR)

During installation, make sure that the silent installation is carried out with an administrator account and not with the Windows account NT_AUTHORITY_SYSTEM. The installation is supposedly carried out successfully, but can subsequently lead to side effects.

The samples listed below list actual installation file versions. New versions may behave differently and there is no claim to completeness.

Remark:
Sometimes a parameter "REBOOT=ReallySuppress" is used. It suppresses all reboots and reboot prompts at the end of the installation. The installation is properly finished after a reboot of all silent installations.

**TwinCAT Engineering (XAE) without Git:**
```
TC31-FULL-Setup.3.1.4024.55.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1 ACTIVATETCXAESHELLSETTINGS=1"
```

**TwinCAT Engineering (XAE) with Git:**
```
TC31-FULL-Setup.3.1.4024.55.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1 ACTIVATETCXAESHELLSETTINGS=1 GIT_FOR_WINDOWS_MINIMAL_INSTALL_AND_ACCEPT_LICENSE=1""
```

**TwinCAT Runtime (XAR):**
```
TC31-XAR-Setup.3.1.4024.55.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```


# Silent Installation Parameters for TwinCAT Functions for TwinCAT 3.1 Build 4024

**TF1810 | TwinCAT 3 PLC HMI Web**
```
TF1810_1.7.5.1.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF2000 | TwinCAT 3 HMI Server (32 Bit)**
```
TF2000_1.12.760.59.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF2000 | TwinCAT 3 HMI Server (64 Bit)**
```
TF2000_1.12.760.59.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1 HMISERVERARCHITECTURE=64"
```

**TF3300 | TwinCAT 3 Scope Server (XAE)**
```
TF3300 XAE_3.4.3148.15.exe /silent
```

**TF3300 | TwinCAT 3 Scope Server (XAR)**
```
TF3300 XAR_3.4.3148.15.exe /silent
```

**TF3520 | TwinCAT 3 Analytics Storage Provider**
```
TF3520 Analytics Storage Provider_1.0.12.3.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF3600 | TwinCAT 3 Condition Monitoring**
```
TF3600_3.2.27.2.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF3650 | TwinCAT 3 Power Monitoring**
```
TF3650 TC3 Power Monitoring_3.2.33.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF3680 | TwinCAT 3 Filter**
```
TF3680_XAE_1.1.8.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF3800 | TwinCAT 3 Machine Learning Inference Engine**
```
TF38xx-Machine-Learning_3.1.62.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF4100 | TwinCAT 3 Controller Toolbox**
```
TF4100_3.4.1.4.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF4110 | TwinCAT 3 Temperature Controller**
```
TF4110_3.3.2.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF4500 | TwinCAT 3 Speech**
```
TF4500_1.1.8.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF511x | TwinCAT 3 KinematicTransformation**
```
TF511x_3.1.3.21.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1 INSTALLTOTC31=1"
```

**TF5200 | TwinCAT 3 CNC**
```
TF5200 CNC_3.1.3079.20.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF5270 | TwinCAT 3 CNC Virtual NCK Basis**
```
TF527x_1.0.6.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF5400 | TwinCAT 3 Advanced Motion Pack**
```
TF54xx_3.2.38.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF5850 | TwinCAT 3 XTS Extension**
```
TF5850 XTS Technology_3.22.1011.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF5890 | TwinCAT 3 XPlanar**
```
TF5890_3.2209.6.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6100 | TwinCAT 3 OPC UA**
```
TF6100-Client_4.4.38.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
TF6100-OPC-UA-Gateway_4.4.4.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
TF6100-Server_5.1.106.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6120 | TwinCAT 3 OPC DA**
```
TF6120_4.1.96.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6250 | TwinCAT 3 Modbus TCP**
```
TF6250_1.0.66.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6300 | TwinCAT 3 FTP Client**
```
TF6300_3.0.5.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6310 | TwinCAT 3 TCP/IP**
```
TF6310_3.3.20.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6350 | TwinCAT 3 SMS/SMTP**
```
TF6350_1.0.29.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6360 | TwinCAT 3 Virtual Serial COM**
```
TF6360_1.34.0.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6420 | TwinCAT 3 Database Server - Beckhoff**
```
TF6420_3.3.35.5.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6421 | TwinCAT 3 XML Server**
```
TF6421_3.2.32.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6510 | TwinCAT 3 IEC 61850/IEC 61400-25**
```
TF6510_3.1.97.3.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6600 | TwinCAT 3 RFID Reader Communication**
```
TF6600_1.0.3.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6620 | TwinCAT 3 S7 Communication**
```
TF6620_1.1.11.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF6720 | TwinCAT 3 IoT Data Agent**
```
TF6720 IoT Data Agent_1.2.46.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF7xxx | TwinCAT 3 Vision**
```
TF7xxx Functions_4.0.3.5.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF8010 | TwinCAT 3 Building Automation Basic**
```
TF8010 - TC3 Building Automation Basic_3.1.2.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF8040 | TwinCAT 3 Building Automation**
```
TF8040 XAE_5.6.0.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF8310 | TwinCAT 3 Wind Framework - Beckhoff**
```
TF8310_3.1.1.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```

**TF8810 | TwinCAT 3 AES70 (OCA)**
```
TF8810_1.0.3.0.exe /s /clone_wait /v"/qr REBOOT=ReallySuppress ALLUSERS=1"
```
