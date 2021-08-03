function Test-AzureADUserExistence {
<#
    .SYNOPSIS
        Check if an account exists in Azure AD for specified email addresses.
    
    .DESCRIPTION
        The script will connect to public endpoints in Azure AD to find out if an account exists for specified email addresses or not. This script works without any authentication to Azure AD. The script can't see accounts for federated domains but it will tell you what organisation the federated domain belongs to.
    
    .PARAMETER Users
        An array of one or more user email addresses to test.
    
    .EXAMPLE
        Test-AzureADUserExistence -Users "user1@example.com", "user2@example.com", "user3@example.onmicrosoft.com"
    
    .NOTES
        Version:        1.0
        Author:         Daniel Chronlund
        Creation Date:  2020-03-12
        
        Warning: This script is a proof of concept and for testing purposes only. Do not use this script in an unethical or unlawful way.
#>

    param ($Users)

    foreach ($User in $Users) {
        # Create custom object for output.
        $TestObject = New-Object -TypeName psobject

        # Add username.
        $TestObject | Add-Member -MemberType NoteProperty -Name "Username" -Value $User

        # Check if user account exists in Azure AD.
        if (((Invoke-WebRequest -Method "POST" -Uri "https://login.microsoftonline.com/common/GetCredentialType" -Body "{`"Username`":`"$User`"}").Content | ConvertFrom-Json).IfExistsResult -eq 0) {   
            # Check domain federation status.
            [xml]$Response = (Invoke-WebRequest -Uri "https://login.microsoftonline.com/getuserrealm.srf?login=$User&xml=1").Content

            # Add org information.
            $TestObject | Add-Member -MemberType NoteProperty -Name "FederationBrandName" -Value $Response.RealmInfo.FederationBrandName
            
            # If domain is Federated we can't tell if the account exists or not :(
            if ($Response.RealmInfo.IsFederatedNS -eq $true) {
                $TestObject | Add-Member -MemberType NoteProperty -Name "UserExists" -Value "Unknown (Federated domain handled by $((($Response.RealmInfo.AuthURL -split "//")[1] -split "/")[0]))"
            }
            # If the domain is Managed (not federated) we can tell if an account exists in Azure AD :)
            else {
                $TestObject | Add-Member -MemberType NoteProperty -Name "UserExists" -Value "Yes"
            }
        }
        else {
            $TestObject | Add-Member -MemberType NoteProperty -Name "UserExists" -Value "No"
        }

        $TestObject
    }   
}


# Example:
Test-AzureADUserExistence -Users "user1@example.com", "user2@example.com", "sam@verboon.online"