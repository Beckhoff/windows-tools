##########################
## Change User Password
##########################

$username = "Administrator"
$password = "TwinCAT123"
$passwordSec = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create new user account if it does not exist
$account = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

# Change Password if User Exists
if (-not ($null -eq $account)) {
    $account = Get-LocalUser -Name $username
    $account | Set-LocalUser -Password $passwordSec
}
else {
    Write-Host "User named $username does not exist"
}

###################################