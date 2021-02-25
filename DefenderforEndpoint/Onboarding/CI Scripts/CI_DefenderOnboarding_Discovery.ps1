<#
.Synopsis
   CI_DefenderOnboarding_Discovery.ps1
.DESCRIPTION
    Script for Configuration Manager - Configuration Item
    CI_DefenderOnboarding_Discovery checks the Defender for Endpoint onboarding state
.NOTES
    v1.0, 25.02.2021, alex verboon
#>

Try{
    $registryValue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"
        if($registryValue.OnboardingState -eq 1){
        return $True
        }else{
        return $False
        }
    }Catch{
    $False
    }