# Configures the Device Lockdown Features of Windows IoT Enterprsie  
# Version 1.7

# Official Microsoft Documentation:
# https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/shell-launcher
# https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/keyboardfilter
# https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/unbranded-boot
# https://learn.microsoft.com/en-us/windows-hardware/customize/enterprise/custom-logon


##########################
# Define Parameters
##########################
# Shell Launcher
$ConfigureShellLauncher=$TRUE
$ConfigNewUser=$TRUE #Resets existing user and creates a new one with user rights and configered Autologon
$username = "Operator"
$password = "123" # The defined  password must comply with the password policy. Default: Minimum password length = 3 characters
$customShellApp="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --kiosk www.beckhoff.com --edge-kiosk-type=fullscreen"

# Define actions to take when the shell program exits.
$Shell_Launcher_Exit_Action = 0  # Restart Shell
#$Shell_Launcher_Exit_Action = 1  # Restart Device
#$Shell_Launcher_Exit_Action = 2  # Shutdown Device
#$Shell_Launcher_Exit_Action = 3  # Do Nothing
###########################
# Keyboard Filter 
$ConfigureKeyboardFilter=$TRUE
$FilteredKeys=@("Ctrl+Alt+Del","Win+L","Win+E","Win+R")
$BreakoutKey="91" #in DEC
	# This setting specifies the scan code of the key that enables a user to break out of an account that is locked down with Keyboard Filter.
    # A user can press this key consecutively five times to switch to the Welcome screen.
    # The scan code of the key can be looked up here:  
    # https://kbdlayout.info/KBDGR/scancodes?arrangement=ISO105
    # By default, the BreakoutKeyScanCode is set to the scan code for the left Windows logo key (HEX=5B, DEC=91).
$DisableKeyboardFilterForAdministrator=$TRUE
###########################
# Unbranded Boot 
$ConfigureUnbrandedBoot=$TRUE
###########################
# Custom Logon 
$ConfigureCustomLogon=$TRUE
$HideAutoLogonUI=$TRUE
$BrandingNeutral=$TRUE

##########################
# Define global Variable 
$Global:ShellLauncherClass=$null
$CommonParams = @{ "namespace" = "root\standardcimv2\embedded" };
if ($PSBoundParameters.ContainsKey("ComputerName"))
{
  $CommonParams += @{ "ComputerName" = $ComputerName };
} 
##########################

# Create a function to retrieve the SID for a user account on a machine.
function Get-UsernameSID($AccountName) {

    $NTUserObject = New-Object System.Security.Principal.NTAccount($AccountName)
    $NTUserSID = $NTUserObject.Translate([System.Security.Principal.SecurityIdentifier])

    return $NTUserSID.Value
}

# Log the actions of the script in a log file
Function Log-Message()
{
 param
    (
    [Parameter(Mandatory=$TRUE)] [string] $Message
    )
 
    Try {
 
        # Get the location of the script
        If ($psise) {
            $CurrentDir = Split-Path $psise.CurrentFile.FullPath
        }
        Else {
            $CurrentDir =  $PSScriptRoot
        }
 
        # Frame log file with current directory and date
        $LogFile = $CurrentDir+ "\" + "Device_Lockdown_Log.txt"
 
        # Add content to the log file
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss:fff tt")
        $Line = "$TimeStamp - $Message"
        Add-content -Path $Logfile -Value $Line
 
        Write-host "Message: '$Message' Has been Logged to File: $LogFile"
    }
    Catch {
        Write-host -f Red "Error:" $_.Exception.Message
    }
}
# Enables the required Device Lockdown features
function Enable-LockdownFeatures
{
    if($ConfigureShellLauncher -eq $TRUE)
    {
    # Create a handle to the class instance to call the static methods
    try {
       
        $NAMESPACE= $CommonParams.namespace
        $COMPUTER=$CommonParams.ComputerName
        $Global:ShellLauncherClass = [wmiclass]"\$COMPUTER${NAMESPACE}:WESL_UserSetting"

        
        } catch [Exception] {
        Log-Message ("Shell Launcher is currently disabled")
        Log-Message ($_.Exception.Message)
        Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedShellLauncher -All -NoRestart -OutVariable result
        $Global:ShellLauncherClass =  [wmiclass]"\$COMPUTER${NAMESPACE}:WESL_UserSetting"   
        Log-Message ("Shell Launcher is enabled")
        }
    }
    if($ConfigureKeyboardFilter -eq $TRUE)
    {        
        $featureName = "Client-KeyboardFilter"
        $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
        $isEnabled = $featureStatus.State -eq 'Enabled'
        if(!$isEnabled)
        {
            try
            {
            # Write event log
            Log-Message ("Keyboard Filter is currently disabled")
            
            # Enable keyboard filter feature without restart		
            Enable-WindowsOptionalFeature -Online -FeatureName Client-KeyboardFilter -All -NoRestart -OutVariable result			
            
                # Detect if restart is required
            if ($result.RestartNeeded -eq $TRUE)
            {
                $restartneeded = $TRUE
                Log-Message ("Required restart for enable the Keyboard Filter")
            }			
            }
            catch
            {
            # Something went wrong, display the error details and write an error to the event log
            Log-Message ("$_.Exception.Message")
            }         
        }
    }

    if($ConfigureUnbrandedBoot -eq $TRUE)
    {        
        $featureName = "Client-EmbeddedBootExp"
        $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
        $isEnabled = $featureStatus.State -eq 'Enabled'
        if(!$isEnabled)
        {
            try
            {
                # Write event log
                Log-Message ("Unbranded Boot is currently disabled")
                
                # Enable Unbranded Boot feature without restart		
                Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedBootExp -All -NoRestart -OutVariable result			
                
                    # Detect if restart is required
                if ($result.RestartNeeded -eq $TRUE)
                {
                    $restartneeded = $TRUE
                    Log-Message ("Required restart for enable the Unbranded Boot")
                }			
            }
            catch
            {
            # Something went wrong, display the error details and write an error to the event log
            Log-Message ("$_.Exception.Message")
            }         
        }
    }
    if($ConfigureCustomLogon -eq $TRUE)
    {        
        $featureName = "Client-EmbeddedLogon"
        $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
        $isEnabled = $featureStatus.State -eq 'Enabled'
        if(!$isEnabled)
        {
            try
            {
            # Write event log
            Log-Message ("Custom Logon is currently disabled")
            
            # Enable Custom Logon feature without restart		
            Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedLogon -All -NoRestart -OutVariable result			
            
                # Detect if restart is required
            if ($result.RestartNeeded -eq $TRUE)
            {
                $restartneeded = $TRUE
                Log-Message ("Required restart for enable the Custom Logon")
            }			
            }
            catch
            {
            # Something went wrong, display the error details and write an error to the event log
            Log-Message ("$_.Exception.Message")
            }         
        }
    }

    # If feature installed and requires restart, then restart		
    if ($restartneeded -eq $TRUE)
    {
        $Message = "A restart is required for changes to take effect before continuing."
        Log-Message ($Message)
        Write-Host $Message 

        $Message = "You must restart the script manually after the restart has completed."
        Log-Message ($Message)
        Write-Host $Message -ForegroundColor Yellow


        Write-Host "Do you want to restart now? [Y/N]"
        $confirmation = Read-Host

        if ($confirmation -eq "y" -or $confirmation -eq "Y") {
            Restart-Computer -Force
        }
        Exit
    }

}
function Check-ShellLauncherLicenseEnabled
{
    [string]$source = @"
using System;
using System.Runtime.InteropServices;

static class CheckShellLauncherLicense
{
    const int S_OK = 0;

    public static bool IsShellLauncherLicenseEnabled()
    {
        int enabled = 0;

        if (NativeMethods.SLGetWindowsInformationDWORD("EmbeddedFeature-ShellLauncher-Enabled", out enabled) != S_OK) {
            enabled = 0;
        }
        return (enabled != 0);
    }

    static class NativeMethods
    {
        [DllImport("Slc.dll")]
        internal static extern int SLGetWindowsInformationDWORD([MarshalAs(UnmanagedType.LPWStr)]string valueName, out int value);
    }

}
"@

    $type = Add-Type -TypeDefinition $source -PassThru

    return $type[0]::IsShellLauncherLicenseEnabled()
}
# Create a new user and configure the Shell Launcher 
function Configure-ShellLauncher
{
    if($ConfigNewUser)
    {
        ##########################
        ## Add a new user
        ##########################
        # Create new user account if it does not exist
        $passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

        $account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
        if (-not ($null -eq $account)) {
            Log-Message ("The User "+$username+" already exists. The User will be reseted.")
            $User_Old_SID=Get-UsernameSID($username)
            $Global:ShellLauncherClass.RemoveCustomShell($User_Old_SID)
            Remove-LocalUser -Name $username
        }
        $newUser=New-LocalUser -Name $username -FullName $username -Description "Standard Windows user for custom shell" -Password $passwordSec
        if ($null -eq $newUser) {
         
            Log-Message ("The user "+$username+" cannot be created")
            exit
         }
        Set-LocalUser $username -PasswordNeverExpires $TRUE 
        Log-Message ("The User "+$username+" was created succesfully")
        # Make the user part of the User group
        $groupSID = "S-1-5-32-545" #SID of the Users Group
        Add-LocalGroupMember -SID $groupSID -Member $username



        ##################################
        ## Enable Autologon for the Shell-User
        ##################################

        $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

        Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
        Set-ItemProperty $RegPath "DefaultUsername" -Value "$username" -type String 
        Set-ItemProperty $RegPath "DefaultPassword" -Value "$password" -type String
        Log-Message ("Auto Login for the User "+$username+" is enabled")

        ############################
    }

    # Check if shell launcher license is enabled
   

    [bool]$result = $FALSE

    $result = Check-ShellLauncherLicenseEnabled
    "`nShell Launcher license enabled is set to " + $result
    if (-not($result))
    {
        "`nThis device doesn&#39;t have required license to use Shell Launcher"
        exit
    }




    # This security identifier (SID) responds to the BUILTIN\Administrators group

    $Admins_SID = "S-1-5-32-544"


    # Get the SID for a user account. Rename "Operator" to an existing account on your system to test this script

    $Operator_SID = Get-UsernameSID($username)


    $Global:ShellLauncherClass.SetDefaultShell("cmd.exe", $Shell_Launcher_Exit_Action)

    # Display the default shell to verify that it was added correctly

    $DefaultShellObject = $Global:ShellLauncherClass.GetDefaultShell()

    Log-Message ("Default Shell is set to " + $DefaultShellObject.Shell + " and the default action is set to " + $DefaultShellObject.defaultaction)

    # Set Edge as the shell for "Operator", and restart the machine if Edge is closed


    $ExistingShell =$Global:ShellLauncherClass.GetCustomShell($Operator_SID)
    if (-not ($null -eq $ExistingShell)) {
        Log-Message("The Custom-Sehll for the User with SID "+$Operator_SID+" was removed")
        $Global:ShellLauncherClass.RemoveCustomShell($Operator_SID)
    }

    $Global:ShellLauncherClass.SetCustomShell($Operator_SID, $customShellApp, ($null), ($null), $Shell_Launcher_Exit_Action)

    # Set Explorer as the shell for administrators
    $ExistingShell =$Global:ShellLauncherClass.GetCustomShell($Admins_SID)
    if (-not ($null -eq  $ExistingShell)) {
        Log-Message("The Custom-Sehll for the User with SID "+$Admins_SID+" was removed")
        $Global:ShellLauncherClass.RemoveCustomShell($Admins_SID)
    }
    $Global:ShellLauncherClass.SetCustomShell($Admins_SID, "explorer.exe")

    # View all the custom shells defined
    $C=Get-WmiObject -class WESL_UserSetting  @CommonParams | Select Sid, Shell, DefaultAction
    Log-Message ("Current settings for custom shells: "+ (Out-String -InputObject $C -Width 350))
        
    # Enable Shell Launcher

    $Global:ShellLauncherClass.SetEnabled($TRUE)

    $IsShellLauncherEnabled = $Global:ShellLauncherClass.IsEnabled()

    Log-Message ("Shell Launcher Status is set to " + $IsShellLauncherEnabled.Enabled)

}
function Enable-Predefined-Key($Id)
{		
  $predefined = Get-WMIObject -class WEKF_PredefinedKey @CommonParams |
  where {
    $_.Id -eq "$Id"
  };
      
  if ($predefined)
  {
    $predefined.Enabled = 1;
    $predefined.Put() | Out-Null;
  }
  else
  {
    
    Log-Message ("$Id is not a valid predefined key")
  }
}
function Get-Setting([String] $Name) {
    <#
    .Synopsis
        Get a WMIObject by name from WEKF_Settings
    .Parameter Name
        The name of the setting, which is the key for the WEKF_Settings class.
#>
    $Entry = Get-WMIObject -class WEKF_Settings @CommonParams |
        where {
            $_.Name -eq $Name
        }

    return $Entry
}

function Set-DisableKeyboardFilterForAdministrators([Bool] $Value) {
    <#
    .Synopsis
        Set the DisableKeyboardFilterForAdministrators setting to true or
        false.
    .Description
        Set DisableKeyboardFilterForAdministrators to true or false based
        on $Value
    .Parameter Value
        A Boolean value
#>

    $Setting = Get-Setting("DisableKeyboardFilterForAdministrators")
    if ($Setting) {
        if ($Value) {
            $Setting.Value = "true" 
        } else {
            $Setting.Value = "false"
        }
        $Setting.Put() | Out-Null;
    } else {
        
        Log-Message ("Unable to find DisableKeyboardFilterForAdministrators setting")
    }
}

function Set-BreakoutMode($Value) {


    $Setting  =  Get-Setting("BreakoutKeyScanCode")
    if ($Setting) {
    
        $Setting.Value = $Value
        $Setting.Put() | Out-Null;
        Log-Message ("Configure the scan code "+$Value+" as Breakout Key")
    } else {
        
        Log-Message ("Unable to find BreakoutKeyScanCode setting")
    }
}

function Configure-KeyboardFilter
{
    Set-Service -Name MsKeyboardFilter -StartupType Automatic -Status Running -PassThru
    # Disable keyboard filter for Administrator account
    Set-DisableKeyboardFilterForAdministrators $DisableKeyboardFilterForAdministrator
    #Configure the Breakout Key
    Set-BreakoutMode $BreakoutKey

    # Enable filters
    # Key combinaitons listed below will not be actioned
    Get-WMIObject -class WEKF_Settings @CommonParams -ErrorAction Stop
    foreach($i in $FilteredKeys)
    {
        Enable-Predefined-Key $i
    }
    Log-Message ("Enabled Predefined Keys")
    Get-WMIObject -class WEKF_PredefinedKey @CommonParams |
    foreach {
        if ($_.Enabled) {
            write-host $_.Id
            Log-Message ($_.Id)
        }
    }

    Log-Message ("Enabled Custom Keys")
    Get-WMIObject -class WEKF_CustomKey @CommonParams |
        foreach {
            if ($_.Enabled) {
                write-host $_.Id
                Log-Message ($_.Id)
            }
        }

    Log-Message ("Enabled Scancodes")
    Get-WMIObject -class WEKF_Scancode @CommonParams |
        foreach {
            if ($_.Enabled) {
                "{0}+{1:X4}" -f $_.Modifiers, $_.Scancode
            }
        } 

}

function Configure-UnbrandedBoot
{
    # To disable the F8 key during startup to prevent access to the advanced startup options menu
    cmd /c "bcdedit.exe -set {globalsettings} advancedoptions false"

    # To disable the F10 key during startup to prevent access to the advanced startup options menu
    cmd /c "bcdedit.exe -set {globalsettings} optionsedit false"

    # To suppress all Windows UI elements (logo, status indicator, and status message) during startup
    cmd /c "bcdedit.exe -set {globalsettings} bootuxdisabled on"

    # To disable automatic repair console during startup
    cmd /c "bcdedit.exe -set {current} recoveryenabled NO"

    # To disable bootstatuspolicy at startup
    cmd /c "bcdedit.exe -set {current} bootstatuspolicy ignoreallfailures"
}

function Configure-CustomLogon
{
    if ($BrandingNeutral -eq $TRUE)
    {
        Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name 'BrandingNeutral' -value '00000001'
    }
    else {
        Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name 'BrandingNeutral' -value '00000000'
    }

    if ($HideAutoLogonUI -eq $TRUE)
    {
        Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name 'HideAutoLogonUI' -value '00000001'
    }
    else {
        Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name 'HideAutoLogonUI' -value '00000000'
    }

    Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon' -Name 'HideFirstLogonAnimation' -value '00000001'
}
##########-----------The script starts here---------##################

Log-Message("---------------------------------------")
Enable-LockdownFeatures

if($ConfigureShellLauncher -eq $TRUE)
{
    Configure-ShellLauncher
}

if($ConfigureKeyboardFilter -eq $TRUE)
{
    Configure-KeyboardFilter
}

if($ConfigureUnbrandedBoot -eq $TRUE)
{
    Configure-UnbrandedBoot
}

if($ConfigureCustomLogon -eq $TRUE)
{
    Configure-CustomLogon
}





