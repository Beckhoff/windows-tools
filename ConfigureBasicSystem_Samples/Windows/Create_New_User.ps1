##########################
## Add a new user
##########################

# Create a new user
$username = "TwinCAT_User"
$password = "userpw"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue
if (-not ($null -eq $account)) {
    Remove-LocalUser -Name $username
}
New-LocalUser -Name $username -FullName $username -Description "Standard Windows user" -Password $passwordSec

# Make the user part of the User Group
Add-LocalGroupMember -Group "Users" -Member $username

##########################
