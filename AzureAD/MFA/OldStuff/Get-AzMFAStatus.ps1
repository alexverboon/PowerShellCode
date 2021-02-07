function Get-AzMFAStatus
{
<#
.Synopsis
   Get-AzMFAStatus
.DESCRIPTION
   Get-AzMFAStatus retrieves Multifactor Authentication configuration informationo
   from all registered users within an Azure Active Directory tenant. 
   
    UserPrincipalName             : alex@contoso.com
    DisplayName                   : Alex
    AuthEmail                     : alex@fabrikam.com
    AuthPhoneNumber               : +1 123 456789
    PhoneDeviceName               : Alex’s iPhone
    AuthAltPhone                  : 
    PhoneAppNotification          : True
    PhoneAppNotificationIsDefault : True
    PhoneAppOTP                   : True
    PhoneAppOTPnIsDefault         : False
    TwoWayVoiceMobile             : True
    TwoWayVoiceMobileIsDefault    : False
    OneWaySMS                     : True
    OneWaySMSIsDefault            : False
.PARAMETER UserPrincipalName
  The user ID of the user to retrieve.
.PARAMETER AuthMethod
  Using this parameter allows to filter the results for one of the following MFA Authentication method. 
  PhoneAppNotification
  PhoneAppOTP
  TwoWayVoiceMobile
  OneWaySMS
  email
.PARAMETER IsDefault
 
 Use this parameter in combinaation with parameter AuthMethod to filter the results where the MFA authentication
 method is the default. 
.PARAMETER State
 Using this parameter allows to filter the results for one of the following MFA Authentication states.
 
 Disabled
 Enabled
 Enforced
 
 Note: When using MFA through Conditional Acess, the state always remains Disabled. 
  
.EXAMPLE
    Get-AzMFAStatus
    This command retrieves all users within the domain
.EXAMPLE
    Get-AzMFAStatus -AuthMethod PhoneAppNotification
    This command retrieves all users  that have PhoneAppNotification enabled
.EXAMPLE 
    Get-AzMFAStatus -UserPrincipalName alex@contoso.com
    This command lists the MFA configuration settings for the specified user. 
.EXAMPLE
    Get-AzMFAStatus -State Disabled
    This command lists all users that have MFA explicitely enabled. If you use Conditional access and MFA
    you should not have any uses that have an MFA state of "Enabled" or "Enforced'
.NOTES
    06.02.2019 v1.0, Alex Verboon
    17.03.2020 v1.1, Alex verboon, added user objectguid and improved processing speed. 
    17.03.2020 v1.1, Alex Verboon, added consitency to the 'default' attributes 
    17.03.2020 v1.2, Alex Verboon, adeed fixed a typo in the PhoneAppOTPIsDefault attribute

#>
   [cmdletbinding(DefaultParameterSetName=’User’)]
    Param
    (
        # The Users principalname
        [Parameter(Mandatory=$false,
        ParameterSetName = "User",
        ValueFromPipelineByPropertyName=$true,
        Position=0)]
        [string]$UserPrincipalName,
    
        # The Autentication Method
        [Parameter(Mandatory=$false,
        ParameterSetName = "AuthMethod",
        ValueFromPipelineByPropertyName=$true,
        Position=0)]
        [ValidateSet("PhoneAppNotification","PhoneAppOTP","TwoWayVoiceMobile","OneWaySMS","email")]
        [string]$AuthMethod,

        # Use this swtich to check if the selected authentication method is set as the users default
        [Parameter(Mandatory=$false,
        ParameterSetName = "AuthMethod",
        ValueFromPipelineByPropertyName=$true,
        Position=1)]
       [switch]$IsDefault,

        # Use this switch of check if MFA was enforced through Office 365
        [Parameter(Mandatory=$false,
        ParameterSetName = "State",
        ValueFromPipelineByPropertyName=$true,
        Position=0)]
        [ValidateSet("Enabled","Enforced","Disabled")]
        [string]$State
    )


Begin{
        Try{
            Get-MsolDomain -ErrorAction stop | Out-Null
        }
        Catch{
            write-warning "You must call the Connect-MsolService cmdlet before running Get-AzMFAStatus"
        }
}

Process{
    [int]$TotalItems = 0
    [int]$count = 0
    
    If ([string]::IsNullOrEmpty($UserPrincipalName))
    {
        Try{
        Write-Verbose "Retrieving all users"
        $allusers = Get-MsolUser -All -ErrorAction stop
        }
        Catch{
            Write-Warning "Unable to retrieve users"
        }
    }
    Else
    {
        Try{
        $allusers = Get-MsolUser -UserPrincipalName $UserPrincipalName -ErrorAction Stop 
        }
        Catch{
            Write-Warning "User: $UserPrincipalName not found"
        }
    }

    $TotalItems = $allusers.count
    $count=0
    Write-verbose "Total users in AzureAD: $TotalItems"
    
    $mfauserinfo =  ForEach ($user in $allusers)
    {
        #Write-verbose "Processing $($User.UserPrincipalName) $count/$TotalItems"
        $StrongAuthenticationMethodsresult = $user.StrongAuthenticationMethods | Select-Object MethodType,IsDefault

        #$object = [ordered]@{
            [PSCustomObject]@{
            UserPrincipalName = $user.UserPrincipalName
            ObjectID = $user.objectid
            DisplayName = $user.DisplayName
            AuthEmail = $user.StrongAuthenticationUserDetails.Email
            AuthPhoneNumber = $user.StrongAuthenticationUserDetails.PhoneNumber
            PhoneDeviceName = $user.StrongAuthenticationPhoneAppDetails.DeviceName
            AuthAltPhone = $user.StrongAuthenticationUserDetails.AlternativePhoneNumber
            State = if($user.StrongAuthenticationRequirements.State -ne $null){ $user.StrongAuthenticationRequirements.State} else { "Disabled"}

            PhoneAppNotification = if ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "PhoneAppNotification"}) {$true} else {$false}
            PhoneAppNotificationIsDefault = IF (  ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "PhoneAppNotification"}).isDefault -eq "True") {$true} Else {$false}

            PhoneAppOTP = if ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "PhoneAppOTP"}) {$true} else {$false}
            PhoneAppOTPIsDefault = IF (  ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "PhoneAppOTPIsDefault"}).isDefault -eq "True") {$true} Else {$false}

            TwoWayVoiceMobile = if ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "TwoWayVoiceMobile"}) {$true} else {$false}
            TwoWayVoiceMobileIsDefault = IF (  ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "TwoWayVoiceMobileIsDefault"}).isDefault -eq "True") {$true} Else {$false}

            OneWaySMS = if ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "OneWaySMS"}) {$true} else {$false}
            OneWaySMSIsDefault = IF (  ($StrongAuthenticationMethodsresult | Where-Object {$_.MethodType -eq "OneWaySMSIsDefault"}).isDefault -eq "True") {$true} Else {$false}

        }
        #$count++
     }
}

End{

    If ([string]::IsNullOrEmpty($AuthMethod))
    {
        If ([String]::IsNullOrEmpty($State))
        {
            $mfauserinfo
        }
        Else
        {
            Write-Verbose "Retrieving all users with MFA Enforcement state: $State"
            $mfauserinfo | Where-Object {$_.State -eq "$State"}
        }
    }
    Else
    {
        If ($AuthMethod -eq "email")
        {
            Write-Verbose "Retrieving all users with registered e-mail"
            $mfauserinfo | Where-Object {$_.AuthEmail -cnotlike ""}
        }
        Else
        {
            If ($IsDefault.IsPresent -eq $true)
            {
                    Write-Verbose "Retrieving all users with $AuthMethod set as default"
                    $isdefaultname = "$AuthMethod" + "IsDefault"
                    
                    $mfauserinfo | Where-Object {$_."$AuthMethod" -eq "True"-and $_."$isdefaultname" -eq "True"}
            }
            Else
            {
                    Write-Verbose "Retrieving all users with $AuthMethod enabled"
                    $mfauserinfo | Where-Object {$_."$AuthMethod" -eq "True"}

            }
        }
    }
    
}
}