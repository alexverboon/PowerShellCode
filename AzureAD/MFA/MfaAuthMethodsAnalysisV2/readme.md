# AzureAD - User Authentication Method Inventory

## Install Prerequisites

This script uses Microsoft Graph PowerShell modules

```powershell
find-module -name "Microsoft.graph" | Install-module -Scope CurrentUser
find-module -name Microsoft.Graph.Identity.AuthenticationMethods | install-module -Scope CurrentUser 
```

## Connect to Graph

```powershell
Connect-Graph -Scopes @("UserAuthenticationMethod.Read.All", "User.Read.All" )
```

## Collect AzureAD User Authentication Method information

```powershell
$Authinfo = .\Get-AzureADUserAuthMethodInventory.ps1
```

***Output***
```powershell
userPrincipalName      : john.doe@contoso.com
UserType               : Member
AccountEnabled         : True
id                     : e252875e-8d27-434g-b5e1-32521c11fd25
DisplayName            : John Doe
AuthMethods            : {Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod,
                         Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod,
                         Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod}
AuthMethodsCount       : 3
Phone                  : Yes
MicrosoftAuthenticator : No
Email                  : Yes
HelloForBusiness       : No
fido2                  : No
Password               : Yes
passwordless           : No

userPrincipalName      : sam.lee@contoso.com
UserType               : Member
AccountEnabled         : True
id                     : f481026c-43f5-4c39-9b16-af50faf79c61
DisplayName            : Sam Lee
AuthMethods            : {Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod,
                         Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod,
                         Microsoft.Graph.PowerShell.Models.MicrosoftGraphAuthenticationMethod}
AuthMethodsCount       : 3
Phone                  : No
MicrosoftAuthenticator : Yes
Email                  : No
HelloForBusiness       : Yes
fido2                  : No
Password               : Yes
passwordless           : No

```

