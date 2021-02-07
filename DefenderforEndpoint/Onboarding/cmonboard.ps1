

   #Use the following Code to generate the base64 string
   #$onboardingscript = "C:\dev\onboarding\WindowsDefenderATPOnboardingScript.cmd"
   #$rawContent = Get-Content $onboardingscript -Raw -Encoding UTF8
   #$utf8ByteArray = [System.Text.Encoding]::UTF8.GetBytes($rawContent)
   #$base64OnBoardingString = [System.Convert]:: ToBase64String($utf8ByteArray)


$base64OnBoardingString = "STRING HERE "
$utf8ByteArray = [System.Convert]::FromBase64String($base64OnBoardingString)
$onBoardingScript = [System.Text.Encoding]::UTF8.GetString($utf8ByteArray)

$tempExists = $false

$onBoardingScriptPath = $env:temp
$onBoardingScriptFile = "MDATPOnboarding.cmd"
$fullOnBoardingScriptPath = "$onBoardingScriptPath\$onBoardingScriptFile"

Write-Host "$fullOnBoardingScriptPath"

Try{
    $onBoardingScript | Out-File $fullOnBoardingScriptPath -Encoding utf8
    Start-Process $fullOnBoardingScriptPath -Wait
    Remove-Item -Path $fullOnBoardingScriptPath -Force 
}
Catch{
   Write-Error "Error running MDE onboarding script" 
}


$registryValue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"
if($registryValue.OnboardingState -eq 1)
{
    return 0
} else 
{
    return 1    
}

