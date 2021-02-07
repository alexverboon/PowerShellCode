# on Premise AD
Get-AzADUser 

$aduser = "bgroove"
Disable-ADAccount -Identity $aduser
$pwd1 = (New-Guid).Guid
Set-ADAccountPassword -Identity $aduser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$pwd1" -Force)
$pwd2 = (New-Guid).Guid
Set-ADAccountPassword -Identity $aduser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$pwd2" -Force)


# AzureAD


$rUser = "bgroove@contoso.com"
# Get user Details
Get-AzureADUser -ObjectId $rUser
Get-AzureADUser -ObjectId $rUser | Select UserPrincipalName,AccountEnabled

#disable user
Set-AzureADUser -ObjectId $rUser -AccountEnabled $false

#Revoke
Revoke-AzureADUserAllRefreshToken -ObjectId $ruser

# User Device
Get-AzureADUserRegisteredDevice -ObjectId $rUser
#Get-AzureADUserRegisteredDevice -ObjectId johndoe@contoso.com | Set-AzureADDevice -AccountEnabled $false
