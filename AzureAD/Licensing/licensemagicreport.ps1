

# The command defines the SKUs we're interested in
$SkuScope = Get-AzureADSubscribedSku | Select Sku*, ConsumedUnits ,prepaidunits # | where {$_.SkuPartNumber -eq 'EMSPREMIUM' -or $_.SkuPartNumber -eq 'THREAT_INTELLIGENCE' -or $_.SkuPartNumber -eq 'EMS' -or $_.SkuPartNumber -eq 'IDENTITY_THREAT_PROTECTION' -or $_.SkuPartNumber -eq 'WIN_DEF_ATP'  -or $_.SkuPartNumber -eq 'ENTERPRISEPACK' -or $_.SkuPartNumber -eq 'STANDARDPACK' }


# This data is used to decode the SKUSumValue
$sku_lookup1 = @{
1="EMSPREMIUM"
2="ENTERPRISEPACK"
4="EMS"
8="IDENTITY_THREAT_PROTECTION"
16="WIN_DEF_ATP"
32="STANDARDPACK"
}

#$value = 4
#$decoded = $sku_lookup1.Keys | foreach {$sku_lookup1.item(($_ ) -band $value)}
#$decoded



# This data is used to define the band value for each SKU
$sku_band_value = @{
"WIN_DEF_ATP"                = "1"
"EMS"                        = "2"
"EMSPREMIUM"                 = "4"  
"STANDARDPACK"               = "8"
"ENTERPRISEPACK"             = "16"
"ENTERPRISEPREMIUM"          = "32"
"IDENTITY_THREAT_PROTECTION" = "64"
"FLOW_FREE"                  = "128"
}


$Skutable = @{
 "O365_BUSINESS_ESSENTIALS"      = "Office 365 Business Essentials"
 "O365_BUSINESS_PREMIUM"      = "Office 365 Business Premium"
 "DESKLESSPACK"      = "Office 365 (Plan K1)"
 "DESKLESSWOFFPACK"      = "Office 365 (Plan K2)"
 "LITEPACK"      = "Office 365 (Plan P1)"
 "EXCHANGESTANDARD"      = "Office 365 Exchange Online Only"
 "STANDARDPACK"      = "Office 365 Enterprise Plan E1"
 "STANDARDWOFFPACK"      = "Office 365 (Plan E2)"
 "ENTERPRISEPACK" = "Office 365 Enterprise Plan E3"
 "ENTERPRISEPACKLRG"      = "Enterprise Plan E3"
 "ENTERPRISEWITHSCAL" = "Enterprise Plan E4"
 "STANDARDPACK_STUDENT"      = "Office 365 (Plan A1) for Students"
 "STANDARDWOFFPACKPACK_STUDENT"      = "Office 365 (Plan A2) for Students"
 "ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
 "ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
 "STANDARDPACK_FACULTY"      = "Office 365 (Plan A1) for Faculty"
 "STANDARDWOFFPACKPACK_FACULTY"      = "Office 365 (Plan A2) for Faculty"
 "ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
 "ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
 "ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
 "STANDARD_B_PILOT"      = "Office 365 (Small Business Preview)"
 "VISIOCLIENT"      = "Visio Pro Online"
 "POWER_BI_ADDON" = "Office 365 Power BI Addon"
 "POWER_BI_INDIVIDUAL_USE"      = "Power BI Individual User"
 "POWER_BI_STANDALONE"      = "Power BI Stand Alone"
 "POWER_BI_STANDARD"      = "Power-BI Standard"
 "PROJECTESSENTIALS"      = "Project Lite"
 "PROJECTCLIENT"      = "Project Professional"
 "PROJECTONLINE_PLAN_1"      = "Project Online"
 "PROJECTONLINE_PLAN_2"      = "Project Online and PRO"
 "ProjectPremium" = "Project Online Premium"
 "ECAL_SERVICES"      = "ECAL"
 "EMS"      = "ENTERPRISE MOBILITY + SECURITY E3"
 "RIGHTSMANAGEMENT_ADHOC" = "Windows Azure Rights Management"
 "MCOMEETADV" = "PSTN conferencing"
 "SHAREPOINTSTORAGE"      = "SharePoint storage"
 "PLANNERSTANDALONE"      = "Planner Standalone"
 "CRMIUR" = "CMRIUR"
 "BI_AZURE_P1"      = "Power BI Reporting and Analytics"
 "INTUNE_A"      = "Windows Intune Plan A"
 "PROJECTWORKMANAGEMENT"      = "Office 365 Planner Preview"
 "ATP_ENTERPRISE" = "Exchange Online Advanced Threat Protection"
 "EQUIVIO_ANALYTICS"      = "Office 365 Advanced eDiscovery"
 "AAD_BASIC"      = "Azure Active Directory Basic"
 "RMS_S_ENTERPRISE"      = "Azure Active Directory Rights Management"
 "AAD_PREMIUM"      = "Azure Active Directory Premium"
 "MFA_PREMIUM"      = "Azure Multi-Factor Authentication"
 "STANDARDPACK_GOV"      = "Microsoft Office 365 (Plan G1) for Government"
 "STANDARDWOFFPACK_GOV"      = "Microsoft Office 365 (Plan G2) for Government"
 "ENTERPRISEPACK_GOV" = "Microsoft Office 365 (Plan G3) for Government"
 "ENTERPRISEWITHSCAL_GOV" = "Microsoft Office 365 (Plan G4) for Government"
 "DESKLESSPACK_GOV"      = "Microsoft Office 365 (Plan K1) for Government"
 "ESKLESSWOFFPACK_GOV"      = "Microsoft Office 365 (Plan K2) for Government"
 "EXCHANGESTANDARD_GOV"      = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
 "EXCHANGEENTERPRISE_GOV" = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
 "SHAREPOINTDESKLESS_GOV" = "SharePoint Online Kiosk"
 "EXCHANGE_S_DESKLESS_GOV"      = "Exchange Kiosk"
 "RMS_S_ENTERPRISE_GOV"      = "Windows Azure Active Directory Rights Management"
 "OFFICESUBSCRIPTION_GOV" = "Office ProPlus"
 "MCOSTANDARD_GOV"      = "Lync Plan 2G"
 "SHAREPOINTWAC_GOV"      = "Office Online for Government"
 "SHAREPOINTENTERPRISE_GOV"      = "SharePoint Plan 2G"
 "EXCHANGE_S_ENTERPRISE_GOV"      = "Exchange Plan 2G"
 "EXCHANGE_S_ARCHIVE_ADDON_GOV"      = "Exchange Online Archiving"
 "EXCHANGE_S_DESKLESS"      = "Exchange Online Kiosk"
 "SHAREPOINTDESKLESS" = "SharePoint Online Kiosk"
 "SHAREPOINTWAC"      = "Office Online"
 "YAMMER_ENTERPRISE"      = "Yammer Enterprise"
 "EXCHANGE_L_STANDARD"      = "Exchange Online (Plan 1)"
 "MCOLITE"      = "Lync Online (Plan 1)"
 "SHAREPOINTLITE" = "SharePoint Online (Plan 1)"
 "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
 "EXCHANGE_S_STANDARD_MIDMARKET"      = "Exchange Online (Plan 1)"
 "MCOSTANDARD_MIDMARKET"      = "Lync Online (Plan 1)"
 "SHAREPOINTENTERPRISE_MIDMARKET" = "SharePoint Online (Plan 1)"
 "OFFICESUBSCRIPTION" = "Office ProPlus"
 "YAMMER_MIDSIZE" = "Yammer"
 "DYN365_ENTERPRISE_PLAN1"      = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
 "ENTERPRISEPREMIUM_NOPSTNCONF"      = "Enterprise E5 (without Audio Conferencing)"
 "ENTERPRISEPREMIUM"      = "Office 365 Enterprise E5 (with Audio Conferencing)"
 "MCOSTANDARD"      = "Skype for Business Online Standalone Plan 2"
 "PROJECT_MADEIRA_PREVIEW_IW_SKU" = "Dynamics 365 for Financials for IWs"
 "STANDARDWOFFPACK_IW_STUDENT"      = "Office 365 Education for Students"
 "STANDARDWOFFPACK_IW_FACULTY"      = "Office 365 Education for Faculty"
 "EOP_ENTERPRISE_FACULTY" = "Exchange Online Protection for Faculty"
 "EXCHANGESTANDARD_STUDENT"      = "Exchange Online (Plan 1) for Students"
 "OFFICESUBSCRIPTION_STUDENT" = "Office ProPlus Student Benefit"
 "STANDARDWOFFPACK_FACULTY"      = "Office 365 Education E1 for Faculty"
 "STANDARDWOFFPACK_STUDENT"      = "Microsoft Office 365 (Plan A2) for Students"
 "DYN365_FINANCIALS_BUSINESS_SKU" = "Dynamics 365 for Financials Business Edition"
 "DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
 "FLOW_FREE"      = "Microsoft Flow Free"
 "POWER_BI_PRO"      = "Power BI Pro"
 "O365_BUSINESS"      = "Office 365 Business"
 "DYN365_ENTERPRISE_SALES"      = "Dynamics Office 365 Enterprise Sales"
 "RIGHTSMANAGEMENT"      = "Rights Management"
 "PROJECTPROFESSIONAL"      = "Project Professional"
 "VISIOONLINE_PLAN1"      = "Visio Online Plan 1"
 "EXCHANGEENTERPRISE" = "Exchange Online Plan 2"
 "DYN365_ENTERPRISE_P1_IW"      = "Dynamics 365 P1 Trial for Information Workers"
 "DYN365_ENTERPRISE_TEAM_MEMBERS" = "Dynamics 365 For Team Members Enterprise Edition"
 "CRMSTANDARD"      = "Microsoft Dynamics CRM Online Professional"
 "EXCHANGEARCHIVE_ADDON"      = "Exchange Online Archiving For Exchange Online"
 "EXCHANGEDESKLESS"      = "Exchange Online Kiosk"
 "SPZA_IW"      = "App Connect"
 "WINDOWS_STORE"      = "Windows Store for Business"
 "MCOEV"      = "Microsoft Phone System"
 "VIDEO_INTEROP"      = "Polycom Skype Meeting Video Interop for Skype for Business"
 "SPE_E5" = "Microsoft 365 E5"
 "SPE_E3" = "Microsoft 365 E3"
 "ATA"      = "Advanced Threat Analytics"
 "MCOPSTN2"      = "Domestic and International Calling Plan"
 "FLOW_P1"      = "Microsoft Flow Plan 1"
 "FLOW_P2"      = "Microsoft Flow Plan 2"
 "CRMSTORAGE" = "Microsoft Dynamics CRM Online Additional Storage"
 "SMB_APPS"      = "Microsoft Business Apps"
 "MICROSOFT_BUSINESS_CENTER"      = "Microsoft Business Center"
 "DYN365_TEAM_MEMBERS"      = "Dynamics 365 Team Members"
 "STREAM" = "Microsoft Stream Trial"
 "EMSPREMIUM"                         = "ENTERPRISE MOBILITY + SECURITY E5"
 "THREAT_INTELLIGENCE" = "Office 365 Advanced Threat Protection (Plan 2)"
 "IDENTITY_THREAT_PROTECTION" = "Microsoft 365 E5 Security"
 "WIN_DEF_ATP" = "Microsoft Defender Advanced Threat Protection"
}

<#
# Import all AzureAD User Information
# $UserLicenses = Get-Content -Path "C:\temp\mikron\user_liceneses.csv" | ConvertFrom-Csv
# Add an additional attribute to each record with the SKU band value
$UserLicenses |  ForEach{
    $_ | Add-Member -MemberType NoteProperty -Name "SKUsumValue" -Value ($sku_band_value["$($_.SKUName)"])
    $_ | Add-Member -MemberType NoteProperty -Name "SKUFriendlyName" -Value ($Skutable["$($_.SKUName)"])
    }

#>

# Get All users and their license information and enrich the data with friendly SKU Names and assign a band value for later processing

$UserLicences = [System.Collections.Generic.List[Object]]::new()  
ForEach ($Sku in $SkuScope) {
   Write-host "Processing license holders for" $Sku.SkuPartNumber
   $SkuUsers = Get-AzureADUser -All $True | ? {$_.AssignedLicenses -Match $Sku.SkuId}
   ForEach ($User in $SkuUsers) {
      $Object1  = [PSCustomObject] @{
          User       = $User.DisplayName 
          UPN        = $User.UserPrincipalName
          ObjectID   = $user.ObjectId
          Department = $User.Department
          Country    = $User.Country
          SKU        = $Sku.SkuId
          SKUProductName =  ($Skutable["$($Sku.skupartnumber)"])
          SKUName    = $Sku.SkuPartNumber
          SKUSumValue = ($sku_band_value["$($Sku.SkuPartNumber)"])
          SKUSumNames = $sku_lookup1.Keys | foreach {$sku_lookup1.item(($_ ) -band $value)}
          } 
         $UserLicences.Add($Object1)
     }
}


# Create a unique user list
$UserReference = $UserLicences | Select-Object UPN -Unique
$TotalUsers = $UserReference.Count

# Preparing Details
Write-Output "Preparing details"
$Report = [System.Collections.Generic.List[Object]]::new()  
$count = 0
ForEach($user in $UserReference)
{
       Write-Output "Processing $count / $TotalUsers"
       $alluserskus = $null
       # Get all SKUs assigned to this user
       $alluserskus = @($UserLicences | Select-Object UPN, SKUName,SKUProductName,SKUSumValue |Where-Object {$_.upn -eq $user.UPN})
       # Sum the SKU band values
       $SKUBandValue = (($alluserskus).SKUSumValue | Measure-Object -Sum).Sum
       
       $ReportLine = [PSCustomObject][ordered]@{
           UPN = $user.UPN
           TotalSKUCount = $alluserskus.Count
           SKUBandValue = $SKUBandValue
           SKUDetails = $alluserskus
       }
       $Report.Add($ReportLine)
       $count++
}


