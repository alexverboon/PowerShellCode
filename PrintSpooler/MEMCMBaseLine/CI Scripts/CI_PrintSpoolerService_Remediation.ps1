<#
.Synopsis
   CI_PrintSpoolerService_Remediation
.DESCRIPTION
    Script for Configuration Manager - Configuration Item

   CI_PrintSpoolerService_Remediation sets the start mode of the print spooler to disabled and stops the print spooler service

.NOTES
    v1.0, 10.07.2021, alex verboon
#>

Stop-Service -Name "Spooler" -Force
Set-Service -Name "Spooler" -StartupType Disabled
