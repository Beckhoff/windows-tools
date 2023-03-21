# Device Lockdown Features

The Device Lockdown Features allow you to lock down your Windows System. 
This can be useful to protect the system from malicious users or customize the user experience. 

The Device Lockdown Features are described here:

- [Shell Launcher](#shell-launcher)

- [Unbranded Boot](#unbranded-boot)

- [Keyboard Filter](#keyboard-filter)

- [Custom Logon](#custom-logon)




   
<!-- toc -->
## Shell Launcher
You can use Shell Launcher to configure a custom Shell for a specific Windows User. This script creates a new user and defines any application as custom shell to the user. 

You have to define a username and password for the new user. The new user is logged on automatically after system starts. 
```
# Shell Launcher
$ConfigureShellLauncher=$TRUE
$ConfigNewUser=$TRUE #Resets existing user and creates a new one with user rights and configered Autologon
$username = "Operator"
$password = "1"
$customShellApp="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --kiosk www.beckhoff.com --edge-kiosk-type=fullscreen"
```

You can define an action that should happen after closing the shell:

| **Action** | **Description**   |
|------------|-------------------|
| 0          | Restart the shell |
| 1          | Restart the IPC   |
| 2          | Shut down the IPC |
| 3          | Do nothing        |
```
# Define actions to take when the shell program exits.
$Shell_Launcher_Exit_Action = 0  # Restart Shell
#$Shell_Launcher_Exit_Action = 1  # Restart Device
#$Shell_Launcher_Exit_Action = 2  # Shutdown Device
#$Shell_Launcher_Exit_Action = 3  # Do Nothing
```

Offical Microsoft Documentation:

https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/shell-launcher

## Unbranded Boot

You can suspress Windows elements during the boot phase with Unbranded Boot:   

Before Unbranded Boot:

<img src=img/Before_Unbranded.png  width="500">

After Unbranded Boot:

<img src=img/Unbranded.png  width="500">

You can replace the startup logo with a custom BIOS with an adapted boot screen. The UEFI boot mode is required for this.  

 Official Microsoft Documentation:

 https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/unbranded-boot

## Keyboard Filter
Filter undesirable key presses or key combinations with the Keyboard Filter. This helps to block key combinations like Ctrl+Alt+Delete.
You can exclude the Administrator from these policies. 
 ```
# Keyboard Filter 
$ConfigureKeyboardFilter=$TRUE
$FilteredKeys=@("Ctrl+Alt+Del","Win+L","Win+E","Win+R")
$DisableKeyboardFilterForAdministrator=$TRUE
```
 Official Microsoft Documentation:

 https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/keyboardfilter


## Custom Logon
Custom Logon allows you to disable Windows user logon animations:    
Auto Logon UI:

<img src=img/CustomLogon_HideAutoLogonUI_off.png width="500">

Hide Auto Logon UI:

<img src=img/CustomLogon_HideAutoLogonUI_on.png width="500">

It's also possible to remove the buttons form the Welcome screen. 

Welcome screen:

<img src=img/CustomLogon_withoutBrandingNeutral.png width="500">

Welcome screen with Branding Neutral:

<img src=img/CustomLogon_withBrandingNeutral.png width="500">


 ```
# Custom Logon 
$ConfigureCustomLogon=$TRUE
$HideAutoLogonUI=$TRUE
$BrandingNeutral=$TRUE
 ```

 Official Microsoft Documentation:

https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/custom-logon