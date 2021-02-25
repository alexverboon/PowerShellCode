# Convert the Microsoft Defender for Endpoint onboarding script into a base64 string

# The path to the MDE GPO onboarding script
$onboardingscript = "C:\Data\mde\onboarding\WindowsDefenderATPOnboardingScript.cmd"
$rawContent = Get-Content $onboardingscript -Raw -Encoding UTF8
$utf8ByteArray = [System.Text.Encoding]::UTF8.GetBytes($rawContent)
$base64OnBoardingString = [System.Convert]:: ToBase64String($utf8ByteArray)
$base64OnBoardingString | out-file -FilePath "C:\Data\mde\mdeonboardbase64.txt" -encoding utf8
