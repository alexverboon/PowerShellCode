# Defender for Endpoint - Onboarding Remediation

For more details see: [How to remediate Defender for Endpoint onboarding with ConfigMgr](https://www.verboon.info/2021/02/how-to-remediate-defender-for-endpoint-onboarding-with-configmgr/)

**Convert-MDEOnboardingBase64.ps1**
This is the helper script to convert the onbaordingscript.cmd into a base64 string

**New-CMCIDefenderOnboarding_Remediation.ps1**
Use this script to create a CI for onboarding discovery and remediation, this script will create a CI in Microsoft Endpoint Configuration manager and embed the content of:
CI Scripts\CI_DefenderOnboarding_Discovery.ps1 and CI_DefenderOnboarding_Remediation.ps1

**New-CMCIDefenderOnboarding_Discovery.ps1**
Use this script to create a CI for onboarding discovery only, this script will create a CI in Microsoft Endpoint Configuration manager and embed the content of:
CI Scripts\CI_DefenderOnboarding_Discovery.ps1

**CI Scripts\CI_DefenderOnboarding_Discovery.ps1**
This script contains the code to gather the MDE onboarding state information

**CI Scripts\CI_DefenderOnboarding_Remediation.ps1**
This script executes the MDE onboarding script when the discovery result is false

