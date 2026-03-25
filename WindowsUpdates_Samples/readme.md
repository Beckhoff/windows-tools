# Windows Security Update Installation Sample

**Disclaimer**\
Beckhoff is not responsible for any side effects negatively affecting the real-time capabilities of your TwinCAT control application possibly caused by updates. A backup should be created every time before installing an update. As the installation process of Windows updates requires free disk space, Beckhoff recommends to free at least 10 GB in advance. Only administrators or IT experts should perform the backup and update procedure. 


This script is intended for offline installation with Windows security updates.\
The following points are taken into account:

**UWF (Unified Write Filter) filter status**\
Checks whether the Unified Write Filter is enabled or disabled. It ensures that the script doesn't interfere with systems where UWF is active.

**Volume free space**\
The amount of free space (10 GB) available on the system drive will be checked. It ensures that there's adequate space for performing updates or other operations without causing issues due to insufficient disk space.

**Windows Update Service**\
This checks the status of the Windows Update service, ensuring that it's running. This service is crucial for downloading and installing Windows updates, so ensuring its status is part of maintaining the system's update functionality.

**Directory existence at C:\WinUpdate \ [SSU] \ [MSU] \ [.NET]**\
Verifies the presence of specific directories on the system drive where Windows update files are typically stored. It ensures that the necessary directories for storing update files are present, likely for future update operations.

**Windows Updates properly installed**\
This checks whether Windows updates have been successfully installed on the system. Ensuring that updates are properly installed helps maintain system security and stability by keeping the operating system up-to-date with the latest patches and fixes.

**Removal of properly installed Windows Updates installation files at C:\WinUpdate \ [SSU] \ [MSU] \ [.NET]**\
This part of the script likely cleans up the directories mentioned earlier by removing update installation files that are no longer needed after updates have been successfully installed. This helps free up disk space and keeps the system tidy.


Security Updates for Windows 10 IoT Enterprise 2021 LTSC and 2019 LTSC already contain the SSU files (SSU=Servicing Stack Update).\
For Windows 10 IoT Enterprise 2016 LTSB the SSU files comes as separate installation and needs to be installed in front.

Example:\
**Windows 10 IoT Enterprise 2021 LTSC (KB5035845)**
```
windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu

Already contains the SSU file
.\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64.cab
.\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: WSUSSCAN.cab 
.\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64-pkgProperties.txt
.\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: Windows10.0-KB5035845-x64_uup.xml
.\windows10.0-kb5035845-x64_b4c28c9c57c35bac9226cde51685e41c281e40eb.msu: SSU-19041.4163-x64.cab
```


