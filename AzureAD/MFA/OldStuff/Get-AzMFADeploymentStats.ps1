
function Get-AzMFADeploymentStats
<#
.Synopsis
   Get-AzMFADeploymentStats
.DESCRIPTION
   Get-AzMFADeploymentStats retrieves the MFA registration information from all users in the 
   Tenant and summarizes the results by MFA Authentication mode. 
.EXAMPLE
   Get-AzMFADeploymentStats
.NOTES
    v1.0, 17.03.2020, Alex Verboon, initial version
#>

{
    [CmdletBinding()]
    Param
    (
    
    )

    Begin
    {
        If (Test-Path -Path "$PSScriptRoot\Get-AzMFAStatus.ps1" -PathType Leaf)
        {
            . "$PSScriptRoot\Get-AzMFAStatus.ps1"
        }
        Else
        {
            Write-Error "Script:  $PSScriptRoot\Get-AzMFAStatus.ps1 not found"
            # you find me on github
        }
    }
    Process
    {
      

        Write-verbose "Retrieve all users from the tenant includig their MFA registration information"
        $AllUsers = Get-AzMFAStatus -Verbose
        $MFARegisteredUsers = $AllUsers | Where-Object {$_.OneWaySMSIsDefault -like 'True' -or $_.PhoneAppNotificationIsDefault -like "True" -or $_.PhoneAppOTPIsDefault -like "True" -or $_.TwoWayVoiceMobileIsDefault -like 'True' -or $_.authemail -notlike "" -or $_.AuthPoneNumber -notlike "" -or $_.AuthAltPhone -notlike ""}
        
        Write-Verbose "Users with  SMS As Default"
        $Total_OneWaySMSIsDefault = $MFARegisteredUsers | Where-Object {$_.OneWaySMS -like 'True'-and $_.OneWaySMSIsDefault -like 'True'}
        #$Total_OneWaySMSIsDefault.count

        write-verbose "PhoneAppNotification As Default"
        $Total_PhoneAppNotificationIsDefault = $MFARegisteredUsers | Where-Object {$_.PhoneAppNotification -like 'True' -and $_.PhoneAppNotificationIsDefault -like 'True'}
        #$Total_PhoneAppNotificationIsDefault.count

        Write-verbose "PhoneAppOTP As Default"
        $Total_PhoneAppOTPIsDefault = $MFARegisteredUsers | Where-Object {$_.PhoneAppOTP -like 'True' -and $_.PhoneAppOTPIsDefault -like 'True'}
        #$Total_PhoneAppOTPIsDefault.count

        Write-Verbose "TwoWayVoiceMobileIsDefault As Default"
        $Total_TwoWayVoiceMobileIsDefault = $MFARegisteredUsers | Where-Object {$_.TwoWayVoiceMobile -like 'True' -and $_.TwoWayVoiceMobileIsDefault  -like 'True'}
        #$Total_TwoWayVoiceMobileIsDefault.count

        #write-verbose "Other methods such as auth email, phone number or alternate number"
        #$mailphone = $MFARegisteredUsers | Where-Object {$_.authemail -notlike ""  -or $_.AuthPoneNumber -notlike "" -or $_.AuthAltPhone -notlike ""}
        #$TotaleMail_PhoneOnly = $MFARegisteredUsers | Where-Object {$_.authemail -notlike ""  -or $_.AuthPoneNumber -notlike "" -or $_.AuthAltPhone -notlike "" -and $_.OneWaySMSIsDefault -like 'False' -and $_.PhoneAppNotificationIsDefault -like 'False' -and $_.PhoneAppOTPIsDefault -like 'False'}  
        #$TotaleMail_PhoneOnly.count

        Write-Verbose "Email registratoin only"
        $TotaleMailOnly = $MFARegisteredUsers | Where-Object {$_.authemail -notlike ""  -and $_.AuthPoneNumber -like "" -and $_.AuthAltPhone -like "" -and $_.OneWaySMSIsDefault -like 'False' -and $_.PhoneAppNotificationIsDefault -like 'False' -and $_.PhoneAppOTPIsDefault -like 'False'}  
        #$TotaleMailOnly.count

        Write-Verbose "Phone registratoin only"
        $TotalPhoneOnly = $MFARegisteredUsers | Where-Object {$_.authemail -like ""  -and $_.AuthPoneNumber -notlike "" -and $_.AuthAltPhone -notlike "" -and $_.OneWaySMSIsDefault -like 'False' -and $_.PhoneAppNotificationIsDefault -like 'False' -and $_.PhoneAppOTPIsDefault -like 'False'}  
        #$TotalPhoneOnly.count

        $object = [PScustomObject][ordered]@{
        TotalUsersInTenant = $AllUsers.Count
        TotalUsersMFARegistered = $MFARegisteredUsers.count
        TotalUsersNotMFARegistered = $AllUsers.Count - $MFARegisteredUsers.count
        TotalOneWaySMSIsDefault = $Total_OneWaySMSIsDefault.count
        TotalPhoneAppNotificationIsDefault = $Total_PhoneAppNotificationIsDefault.count
        TotalPhoneAppOTPIsDefault = $Total_PhoneAppOTPIsDefault.count
        TotalTwoWayVoiceMobileIsDefault = $Total_TwoWayVoiceMobileIsDefault.count
        TotaleMailOnly = $TotaleMailOnly.count
        TotalPhoneOnly = $TotalPhoneOnly.count
        }

    $object
    }
    End
    {
    }
}

