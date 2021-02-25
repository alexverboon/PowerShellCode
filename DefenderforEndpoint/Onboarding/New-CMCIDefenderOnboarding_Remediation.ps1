function New-CMCIDefenderOnboarding_Remediation
{
<#
.Synopsis
  New-CMCIDefenderOnboarding_Remediation

.DESCRIPTION
  New-CMCIDefenderOnboarding_Remediation creates a Configuration Item in ConfigMgr to remediate
  devices that are not onboarded into Microsoft Defender for Endpoint

.NOTES
    v1.0, 25.02.2021, alex verboon, initial version
#>

    [CmdletBinding()]
    Param
    (
        # ConfigMgr Site Code
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $SiteCode="P01",
        # ConfigMgr Site Server
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $SiteServer="$ENV:COMPUTERNAME"
    )

    Begin
    {

    #Name and description of the Configuration Item
    $CI_name = 'CI_DefenderforEndpointOnboardingRemediation'
    $CI_desc = "Remediation for MDE onboarding"

    #Name of the CI setting and content of powershellscripts
    $Setting_name = 'Defender for Endpoint onboarding state remediation'
    $Setting_Desc = 'Defender for Endpoint onboarding state remediation'
    $discoverScript_path = "$PSScriptRoot\CI Scripts\CI_DefenderOnboarding_Discovery.ps1"
    $remediationScript_path = "$PSScriptRoot\CI Scripts\CI_DefenderOnboarding_Remediation.ps1"

    #Name and description of the Compliance rule
    $rule_name = 'Defender for Endpoint onboarding state'
    $rule_Desc = 'Defender for Endpoint onboarding state'

   
    #################################################################################
    # NO code edits needed below, unless you need to add additional functionality
    #################################################################################


    # Check if ConfigMgr PowerShell Module is present and can be loaded
    Try{
         if (-not(Get-Module -name ConfigurationManager))
         {
            Write-Verbose "Importing Configuration Manager PowerShell module"
            Import-Module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')
         }
    }
    Catch{
        Write-Error "Unable to load ConfigMgr PowerShell Module"
    }

    # Change the PS Drive to the ConfigMgr Site
    Write-Verbose "ConfigMgr SiteCode: $SiteCode"
    Write-Verbose "ConfigMgr SiteServer: $SiteServer"
    
   
    Try{
        $configMgrDrive =  "$SiteCode" + ":"
        cd $configMgrDrive
        Write-Verbose "Check if User sees the Configuration Item folder"
        Test-Path "ConfigurationItem" -PathType Container 
    }
    Catch
    {
        Write-Error "There was an error connecting to the ConfigMgr Site $SiteCode"
    }

    Write-Verbose "Creating new Configuration Item:"
    Write-Verbose "Name: $CI_name"
    Write-Verbose "Description: $CI_desc"
    Write-Verbose "Setting name: $Setting_name"
    Write-Verbose "Setting Description: $Setting_Desc"
    Write-Verbose "PowerShell Script input: $discoverScript_path"
    Write-Verbose "PowerShell remediation script: $remediationScript_path"
    Write-Verbose "Rule Name: $rule_name"
    Write-Verbose "Rule Description: $rule_Desc"
    
    }
    Process
    {
        Try{
            Write-Verbose "Creating new Configuration Item"
            $CIObject = New-CMConfigurationItem -Name $CI_name -CreationType WindowsOS -Description $CI_desc    

            Write-Verbose "Adding Settings"
            $Setting = Add-CMComplianceSettingScript -InputObject $CIObject -settingName $Setting_name -Description $Setting_Desc -DataType Boolean -DiscoveryScriptLanguage PowerShell -DiscoveryScriptFile $discoverScript_path -noRule -Is64Bit -RemediationScriptFile $remediationScript_path -RemediationScriptLanguage PowerShell 

            Write-Verbose "Adding Rules"
            $setting2 = $CIObject | Get-CMComplianceSetting -SettingName $Setting_name
            $CIRule = $Setting2 | New-CMComplianceRuleValue -ExpressionOperator IsEquals -RuleName $rule_name -ExpectedValue 'True' -NoncomplianceSeverity Critical -RuleDescription $rule_desc -ReportNoncompliance -Remediate
            $CIRuleAdded = Add-CMComplianceSettingRule -InputObject $CIObject -Rule $CIRule
        }
        Catch
        {
            Write-Error "There was an error creating the Configuration Item for $CI_name"
        }
    }
    End
    {
       Get-CMConfigurationItem -Name "$CI_name" -Fast | Sort-Object DateCreated | Select-Object * -Last 1
    }
}

