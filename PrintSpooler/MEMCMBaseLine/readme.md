# Microsoft Endpoint Configuration Manager - Configuration Baseline for Print Spooler

Use the below scripts to create a CI for the Print Spooler Service.

## Content

**New-CMCIPrintSpoolerService.ps1**
Use this script to create a CI for the Windows Print Spooler Service. This script will create a CI in Microsoft Endpoint Configuration manager and embed the content of:
CI Scripts\CI_PrintSpoolerService_Discovery.ps1 and CI_PrintSpoolerService_Remediation.ps1

**CI_PrintSpoolerService_Discovery.ps1**
This script contains the code to gather the Print Spooler running and startup state information.

**CI_PrintSpoolerService_Remediation.ps1**
This script executes when the Print Spooler is running or set to start automatically. The script will disable the print spooler service and stop it. 

## Installation

1. Save the files to your local disk
2. Open the Configuration Manager Console
3. Open PowerShell ISE from the CM Console
4. Switch to the directory where you have saved the scripts. 
5. Load the function included in the script

```PowerShell
 . .\New-CMCIPrintSpoolerService.ps1 
```

6.Run the script to create the CI

```PowerShell
New-CMCIPrintSpoolerService -SiteCode P01 -SiteServer cm01.corp.net -Verbose
```

You now have the CI in the console, next create the Configuration baseline and assign the created CI. Then deploy the baseline to a target collection where you want to have the print spooler service disabled.
