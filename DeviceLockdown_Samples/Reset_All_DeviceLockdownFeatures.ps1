##########################
# Define global Variable 
$username = "Operator"
$Global:ShellLauncherClass=$null
$CommonParams = @{ "namespace" = "root\standardcimv2\embedded" };
if ($PSBoundParameters.ContainsKey("ComputerName"))
{
  $CommonParams += @{ "ComputerName" = $ComputerName };
} 
##########################

# Log the actions of the Script in a Log File
Function Log-Message()
{
 param
    (
    [Parameter(Mandatory=$true)] [string] $Message
    )
 
    Try {
 
        #Get the Location of the script
        If ($psise) {
            $CurrentDir = Split-Path $psise.CurrentFile.FullPath
        }
        Else {
            $CurrentDir =  $PSScriptRoot
        }
 
        #Frame Log File with Current Directory and date
        $LogFile = $CurrentDir+ "\" + "Device_Lockdown_Log.txt"
 
        #Add Content to the Log File
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss:fff tt")
        $Line = "$TimeStamp - $Message"
        Add-content -Path $Logfile -Value $Line
 
        Write-host "Message: '$Message' Has been Logged to File: $LogFile"
    }
    Catch {
        Write-host -f Red "Error:" $_.Exception.Message
    }
}

 # Create a function to retrieve the SID for a user account on a machine.
 function Get-UsernameSID($AccountName) {

    $NTUserObject = New-Object System.Security.Principal.NTAccount($AccountName)
    $NTUserSID = $NTUserObject.Translate([System.Security.Principal.SecurityIdentifier])

    return $NTUserSID.Value
}

##########-----------The script starts here---------##################
Log-Message("---------------------------------------")

#Disable keyboard filter feature without restart		
Disable-WindowsOptionalFeature -Online -FeatureName Client-KeyboardFilter -NoRestart -OutVariable result			

#Detect if restart is needed
if ($result.RestartNeeded -eq $true)
{
    $restartneeded = $true
    Log-Message ("Required restart for disable the Keyboard Filter")
}	

$NAMESPACE= $CommonParams.namespace
$COMPUTER=$CommonParams.ComputerName
$Global:ShellLauncherClass = [wmiclass]"\$COMPUTER${NAMESPACE}:WESL_UserSetting"
 # This security identifier (SID) responds to the BUILTIN\Administrators group.

 $Admins_SID = "S-1-5-32-544"


 # Get the SID for a user account. Rename "Operator" to an existing account on your system to test this script.

 $Operator_SID = Get-UsernameSID($username)

 # Remove the new custom shells.

$Global:ShellLauncherClass.RemoveCustomShell($Admins_SID)

$Global:ShellLauncherClass.RemoveCustomShell($Operator_SID)

#Disable Shell Launcher
$Global:ShellLauncherClass.SetEnabled($FALSE)

$IsShellLauncherEnabled = $Global:ShellLauncherClass.IsEnabled()

Log-Message ("Shell Launcher Status is set to " + $IsShellLauncherEnabled.Enabled)
#Disable shell launcher feature without restart		
Disable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedShellLauncher -NoRestart -OutVariable result


#Detect if restart is needed
if ($result.RestartNeeded -eq $true)
{
    $restartneeded = $true
    Log-Message ("Required restart for disable the Shell Launcher")
}

#Disable Unbranded Boot feature without restart		
Disable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedBootExp -NoRestart -OutVariable result			

#Detect if restart is needed
if ($result.RestartNeeded -eq $true)
{
    $restartneeded = $true
    Log-Message ("Required restart for disable the Unbranded Boot")
}	

#Disable Custom Logon feature without restart		
Disable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedLogon -NoRestart -OutVariable result			

#Detect if restart is needed
if ($result.RestartNeeded -eq $true)
{
    $restartneeded = $true
    Log-Message ("Required restart for disable the Custom Logon")
}	


#If feature uninstalled and required restart, then restart		
if ($restartneeded -eq $true)
{
    Restart-Computer -Confirm:$true -Force
    Exit
}