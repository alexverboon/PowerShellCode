
function Connect-PSMCAS
{
<#
.Synopsis
   Connect-PSMCAS
.DESCRIPTION
   Connect-PSMCAS connects with the MCAS API and sets the $CASCredential variable
   that is used by various functions included in the MCAS PowerShell Module. 
.EXAMPLE
   MCAS-Connect
#>
    [CmdletBinding()]
    Param
    (
        # MCAS Token, generated withn the MCAS Console
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$MCASToken,
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$MCASUrl
    )
    Begin
    {
        try {
            Import-Module MCAS -ErrorAction Stop -Verbose:$false}
        catch
            {Write-Error "MCAS module failed to Import. Terminating the script. More details : $_" 
            Exit(1)
        }

    }
    Process
    {
        $User=$MCASUrl
        $PWord=ConvertTo-SecureString -String "$MCASToken" -AsPlainText -Force
        $CASCredential=New-Object -TypeName System.Management.Automation.PSCredential -argumentList $User, $PWord
        $Credential=$CASCredential
        $CASCredential

        Try{
            $Conf=Get-MCASConfiguration -Credential $CASCredential -ErrorAction Stop
            If(-not ([string]::IsNullOrEmpty($Conf)))
            {
                Write-verbose "Connection to MCAS $MCASUrl OK!"
            }

        }
        Catch
        {
            write-error "Can't run the MCAS cmdlet Get-MCASConfiguration, something isn't working!"
        }
    }
    End
    {
    }
}
