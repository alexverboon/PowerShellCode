
<#PSScriptInfo
.VERSION 1.0.0
.GUID c1b0b9d0-5fc1-494c-b746-46d8d4543b48
.AUTHOR Alex Verboon
.TAGS AzureAD, Identity, Authentication, MFA
.PROJECTURI "https://github.com/alexverboon/PowerShellCode/tree/main/AzureAD/MFA/MfaAuthMethodsAnalysisV2"
.DESCRIPTION This script retrieves AzureAD User Authentication Method information
.SYNOPSIS This script retrieves AzureAD User Authentication method information. 
.EXAMPLE
    Connect-Graph -Scopes @("UserAuthenticationMethod.Read.All", "User.Read.All" )
    $AuthInfo = .\Get-AzureADUserAuthMethodInventory.ps1
.NOTES
    Author:           Alex Verboon
    Creation Date:    07.02.2021
    Update:           25.04.2022, Updated to work with required modules, adjusted code to reflect graph changes in MgUserAuthenticationMethod return object
#>
#Requires -Modules Microsoft.Graph.Users, Microsoft.Graph.Identity.SignIns

if ($null -eq $(Get-MgContext)) {
       Throw "Authentication needed, call 'Connect-Graph -Scopes @(`"UserAuthenticationMethod.Read.All`",`"User.Read.All`")'."
}

Try{
    Select-MgProfile -Name Beta 
    $AllUsers = Get-mguser -all
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
                Phone                  = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.phoneAuthenticationMethod") {"Yes"} Else{"No"}
                MicrosoftAuthenticator = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod") {"Yes"} Else{"No"}
                Email                  = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.emailAuthenticationMethod") {"Yes"} Else{"No"}
                HelloForBusiness       = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod") {"Yes"} Else{"No"}
                fido2                  = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.fido2AuthenticationMethod") {"Yes"} Else{"No"}
                Password               = If ($UserAuthMethod.additionalproperties.values  -match "#microsoft.graph.passwordAuthenticationMethod") {"Yes"} Else{"No"}
                passwordless           = If ($UserAuthMethod.additionalproperties.values -match "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod") {"Yes"} Else{"No"}
            }
        [void]$AuthInfo.Add($object)
    }
    $AuthInfo
}
Catch
{
    Write-Error $PSItem   
}
