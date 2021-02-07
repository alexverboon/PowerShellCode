
# load the function to add users form list to AD group
cd C:\DATA\MFA 
. .\Add-mUserToGroup.ps1
# Collect MFA Status information
#$mfa = .\MfaAuthMethodsAnalysis.ps1 -TenantId ""
# Get all users that have MFA enabled
# $MFA_Active  = @($MFA | Where-Object {$_.MfaAuthMethodCount -gt 0})
# STore usernames in text file 
# $MFA_Active | Select-Object -ExpandProperty UserPrincipalName | out-file -FilePath C:\Data\mfa\Userlist\mfa_active_11122020.txt
# Add users to MFA Group
Add-mUserToGroup -InputFile "C:\Data\MFA\Userlist\newusers_27012021.txt" -Group "AllMFAUsers" -Verbose 
# run this command to list all users of the group
#$cagrpmembers = Get-ADGroupMember -Identity "AllMFAUsers" | Select-Object Name, SamAccountName



