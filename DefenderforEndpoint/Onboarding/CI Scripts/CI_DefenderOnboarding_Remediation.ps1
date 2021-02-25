<#
.Synopsis
   CI_DefenderOnboarding_Remediation
.DESCRIPTION
    Script for Configuration Manager - Configuration Item
    CI_DefenderOnboarding_Remediation reruns the MDE onboarding script

    Use the Convert-MDEOnboardingBase64.ps1 to convert the MDE onboarding script
    into a base64 string that is used for the variable $Base64OnboardingString defined
    in the script below

.NOTES
    v1.0, 25.02.2021, alex verboon
#>

Try{
    $Base64OnboardingString = "<encoded string goes here>"
    $utf8ByteArray = [System.Convert]::FromBase64String($base64OnBoardingString)
    $onBoardingScript = [System.Text.Encoding]::UTF8.GetString($utf8ByteArray)
    $onBoardingScriptPath = $env:temp
    $onBoardingScriptFile = "MDATPOnboarding.cmd"
    $FullOnboardingScriptPath = "$onBoardingScriptPath\$onBoardingScriptFile"
    $onBoardingScript | Out-File $FullOnboardingScriptPath -encoding utf8
    Start-Process $FullOnboardingScriptPath -wait
    Remove-Item -Path $FullOnboardingScriptPath -Force
}
Catch{
    # Error running MDE script
}


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
