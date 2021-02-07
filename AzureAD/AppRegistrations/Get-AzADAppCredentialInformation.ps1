<#
.Synopsis
   Get-AzADAppCredentialInformation
.DESCRIPTION
   Get-AzADAppCredentialInformation
.PARAMETER AppCredentialsExpiringThreshold
 The number of days until an App Registration credential expires
.PARAMETER Detail
 Shows detailed start and end dates of registered credentials

 .EXAMPLE
   Get-AzADAppCredentialInformation

 .EXAMPLE
   Get-AzADAppCredentialInformation -Details
#>
    [CmdletBinding()]
    Param
    (
        # Number of days until the App Registration credential expires
        [Parameter(Mandatory=$false)]
        $AppCredentialsExpiringThreshold,
        # show detiled credential start end dates
        [switch]$Detail
    )
    Begin
    {
        # Azure AD connect
        if (-not (Get-AzContext)){
            write-error "No subscription found in the context.  Please ensure that the credentials you provided are authorized to access an Azure subscription, then run Connect-AzAccount to login."
            Break
        }   
        
        # Set the AppCredentialsExpiringThreshold to 360 if nothing is specified
        If ($AppCredentialsExpiringThreshold -eq $null){
        [int]$AppCredentialsExpiringThreshold = 360
        }
        Write-Verbose "AppCredentialsExpiringThreshold: $AppCredentialsExpiringThreshold"
    }
    Process
    {
        $Result = [System.Collections.ArrayList]::new()
        $CredResult = [System.Collections.ArrayList]::new()
        Write-Output "Retrieving App Registrations..."
        $AppRegs = Get-AzADApplication
        ForEach($app in $AppRegs){
            Write-Verbose "Retrieving credential information: $($app.DisplayName)"
            $AppCredentials = @(Get-AzADAppCredential -ObjectID "$($App.Objectid)")
            $AppCredentialsExpiredCount=0
            $AppCredentialsExpiring=0
            $credState=$null
            ForEach($cred in $AppCredentials){
                $expdays = (New-TimeSpan -Start (Get-Date).ToUniversalTime() -End $cred.EndDate).Days
                Write-Verbose "Expiring Days: $expdays"
                If($expdays -lt 0){
                    $AppCredentialsExpiredCount++
                    $credState = "Expired"
                }
                ElseIf($expdays -lt $AppCredentialsExpiringThreshold){
                    $AppCredentialsExpiring++
                    $credState = "Expiring"
                }
                Else{
                    $credState = "OK"
                }
                $credObject = [PSCustomObject]@{
                    DisplayName = $app.DisplayName
                    StartDate   = $cred.StartDate
                    EndDate     = $cred.EndDate
                    KeyId       = $cred.KeyId
                    Type        = $cred.Type
                    State       = $credState
                }
                [void]$CredResult.Add($credObject)
            }
            $object = [PSCustomObject]@{
                DisplayName                = $app.DisplayName
                ObjectId                   = $app.Objectid
                ApplicationId              = $app.ApplicationId
                AvailableToOtherTenants    = $app.AvailableToOtherTenants
                AppCredentials             = $AppCredentials
                AppCredentialsCount        = $AppCredentials.Count
                AppCredentialsExpiredCount = $AppCredentialsExpiredCount
                AppCredentilsExpiring      = $AppCredentialsExpiring
            }
            [void]$Result.Add($object)
        }
        If ($PSBoundParameters.Keys.Contains('Detail'))
        {
            $CredResult
        }
        Else
        {
            $Result
        }
    }
    End
    {}







