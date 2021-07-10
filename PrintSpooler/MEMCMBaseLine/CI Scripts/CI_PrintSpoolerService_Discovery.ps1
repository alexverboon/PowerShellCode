<#
.Synopsis
   CI_PrintSpoolerService_Discovery
.DESCRIPTION
    Script for Configuration Manager - Configuration Item

    CI_PrintSpoolerService_Discovery checks whether the Windows Print Spooler Service is stopped and StartMode set to disabled

   The status of the Windows Print Spooler 'Spooler' must be 'Stopped' and the Start Mode must be set to 'Disabled'

   All attributes must return true, otherwise the CI returns false

.NOTES
    v1.0, 10.07.2021 alex verboon
#>

Try{
    $PrintSpoolerServiceStatus = (Get-Service -Name "Spooler").Status
    $PrintSpoolStartMode =  (Get-Service -Name Spooler).StartType
    If ($PrintSpoolerServiceStatus -eq "Stopped" -and $PrintSpoolStartMode -eq "Disabled")
    {
        Return $True
    }
    Else
    {
        Return $False
    }
}
Catch{
    $False
}

