# run the modified mfa info gathering script stored here
#  https://gist.github.com/alexverboon/f8fd3300dcf999e1a5f5554cad05030d

$mfa = .\MfaAuthMethodsAnalysis.ps1 -TenantId "YOUR TEANANT ID"
$MFA_Inactive  = @($MFA | Where-Object {$_.MfaAuthMethodCount -eq 0})
$MFA_Active    = @( $MFA | Where-Object {$_.MfaAuthMethodCount -gt 0})
$MFA_Inactive_NoLicense  = @($MFA | Where-Object {$_.MfaAuthMethodCount -eq 0 -and $_.IsLicensed -eq $False})
$MFA_Active_NoLicense    = @($MFA | Where-Object {$_.MfaAuthMethodCount -gt 0 -and $_.IsLicensed -eq $False})
$MFA_InActive_HasLicense = @($MFA | Where-Object {$_.MfaAuthMethodCount -eq 0 -and $_.IsLicensed -eq $true})
$MFA_Active_HasLicense   = @($MFA | Where-Object {$_.MfaAuthMethodCount -gt 0 -and $_.IsLicensed -eq $true})
$MFA_Guests_MFA_Active   = @($mfa | Where-Object {$_.UserPrincipalName -like "*#EXT*" -and $_.MfaAuthMethodCount -gt 0 } )

$MFAResults = [PSCUSTOMOBJECT][ordered]@{
    MFA_Active              = $MFA_Active.Count
    MFA_Inactive            = $MFA_Inactive.Count
    MFA_Inactive_NoLicense  = $MFA_Inactive_NoLicense.Count
    MFA_Active_NoLicense    = $MFA_Active_NoLicense.Count
    MFA_InActive_HasLicense = $MFA_InActive_HasLicense.Count
    MFA_Active_HasLicense   = $MFA_Active_HasLicense.Count
    MFA_Guests_Active       = $MFA_Guests_MFA_Active.Count
}

$MFAResults
