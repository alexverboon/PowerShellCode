
<#PSScriptInfo
.VERSION 1.0.0
.GUID c1b0b9d0-5fc1-494c-b746-46d8d4543b48
.AUTHOR Alex Verboon
.TAGS AzureAD, Identity, Authentication, MFA
.PROJECTURI ""
.DESCRIPTION This script retrieves AzureAD User Authentication Method information
.SYNOPSIS This script retrieves AzureAD User Authentication method information. 
.EXAMPLE
    Connect-Graph -Scopes @("UserAuthenticationMethod.Read.All", "User.Read.All" )
    $AuthInfo = .\Get-AzureADUserAuthMethodInventory.ps1
.NOTES
    Author:           Alex Verboon
    Creation Date:    07.02.2021
#>
##Requires -Module @{ ModuleName = 'Microsoft.Graph.Users'; RequiredVersion = '1.3.1'} ,@{ ModuleName = 'Microsoft.Graph.Identity.AuthenticationMethods'; RequiredVersion = '0.9.1'} 


if ($null -eq $(Get-MgContext)) {
       Throw "Authentication needed, call 'Connect-Graph -Scopes @(`"UserAuthenticationMethod.Read.All`",`"User.Read.All`")'."
}

Try{
    Select-MgProfile -Name Beta 
    $AllUsers = Get-mguser
    $AuthInfo = [System.Collections.ArrayList]::new()
    ForEach ($user in $allUsers){
        $UserAuthMethod = $null
        $UserAuthMethod = Get-MgUserAuthenticationMethod -UserId "$($user.id)"
        $object = [PSCustomObject]@{
                userPrincipalName      = $user.userPrincipalName
                UserType               = $user.UserType
                AccountEnabled         = $user.AccountEnabled
                id                     = $user.id
                DisplayName            = $user.Displayname
                AuthMethods            = $UserAuthMethod
                AuthMethodsCount       = ($UserAuthMethod).count
                Phone                  = If ($UserAuthMethod.values -match "#microsoft.graph.phoneAuthenticationMethod") {"Yes"} Else{"No"}
                MicrosoftAuthenticator = If ($UserAuthMethod.values -match "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod") {"Yes"} Else{"No"}
                Email                  = If ($UserAuthMethod.values -match "#microsoft.graph.emailAuthenticationMethod") {"Yes"} Else{"No"}
                HelloForBusiness       = If ($UserAuthMethod.values -match "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod") {"Yes"} Else{"No"}
                fido2                  = If ($UserAuthMethod.values -match "#microsoft.graph.fido2AuthenticationMethod") {"Yes"} Else{"No"}
                Password               = If ($UserAuthMethod.values -match "#microsoft.graph.passwordAuthenticationMethod") {"Yes"} Else{"No"}
                passwordless           = If ($UserAuthMethod.values -match "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod") {"Yes"} Else{"No"}
            }
        [void]$AuthInfo.Add($object)
    }
    $AuthInfo
}
Catch
{
    Write-Error $PSItem   
}
