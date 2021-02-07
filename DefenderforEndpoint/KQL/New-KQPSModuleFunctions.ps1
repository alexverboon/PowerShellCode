function New-KQPSModuleFunctions
{
<#
.Synopsis
   New-KQPSModulecmdlets
.DESCRIPTION
   New-KQPSModulecmdlets creates kusto query to search for PowerShell commands
   included in the specified PowerShell module name
.PARAMETER ModuleName
    The name of the PowerShell module

.PARAMETER ImportPsd
    The path to the PowerShell module psd file

.PARAMETER Path
    The path where the generated kql query is saved

.EXAMPLE
    New-KQPSModuleFunctions -ImportPsd C:\temp\powersploit.psd1 

    This command creates a kql query including all functions included in the Powersploit 
    module and saves the query to the clipboard

.EXAMPLE
    New-KQPSModuleFunctions -ImportPsd C:\temp\powersploit.psd1 -Path C:\Temp

    This command creates a kql query including all functions included in the powersploit 
    module and saves the query to c:\temp\ps_powersploit.kql

.EXAMPLE
    New-KQPSModuleFunctions -ModuleName netsecurity

    This command creates a kql query including all functions included in the netsecurity 
    module and saves the query to the clipboard

.EXAMPLE
    New-KQPSModuleFunctions -ModuleName netsecurity -Path c:\temp

    This command creates a kql query including all functions included in the netsecurity 
    module and saves the query to c:\temp\ps_netsecurity.kql

.NOTES
    Author: Alex Verboon
    Date: 11.07.2020
    Version 1.0
#>
    [CmdletBinding()]
    Param
    (
        # PowerShell Module
        [Parameter(ParameterSetName='Module',Mandatory=$true)]
        $ModuleName,
        # The path to the PowerShell module psd1 file
        [Parameter(ParameterSetName='Import',mandatory=$true)]
        $ImportPsd,
         # The path where the kql query is saved
        [Parameter(mandatory=$false)]
        $Path
    )

    Begin{}
    Process
    {
    If ($ImportPsd){
        $psdcontent = Import-PowerShellDataFile -Path $ImportPsd
        $PsCmds = ($psdcontent.FunctionsToExport) -join '","' 
        $ModuleVersion = $psdcontent.ModuleVersion
        $ModuleName = (Split-Path $ImportPsd -Leaf).Split(".")[0]
    }
    Else{
        if (-not (Get-Module -ListAvailable -Name $ModuleName)){
        Write-Error "Specified Module $ModuleName not found"
        break} 
        $PsCmds = (get-command -Module "$ModuleName").Name -join '","' 
        $ModuleInfo = Get-Module -Name "$ModuleName"
        $ModuleVersion = $ModuleInfo.Version
    }
    $let = 'let pscommands = dynamic ([' + '"' + $PsCmds + '"' + ']);'
$kqlquery = @"
// Search for PowerShell commands included in the PowerShell module: $ModuleName Version:$ModuleVersion)
$let
DeviceEvents
| where ActionType contains "PowerShellCommand"
| where AdditionalFields has_any (pscommands)
"@
    }
    End{
        If($Path){
        If (Test-Path $Path){
            Write-Output "Saving KQL query to $path\kql_$ModuleName.kql"
            Set-Content -Path "$path\ps_$ModuleName.kql" -Value $kqlquery -Force
            }
        }
        Else{
            Write-Output "KQL query saved to clipboard"
            $kqlquery | clip
        }
   }
}
