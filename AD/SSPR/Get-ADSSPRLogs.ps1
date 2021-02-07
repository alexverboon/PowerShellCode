
function Get-ADSSPRLogs
{
<#
.Synopsis
   Get-ADSSPRLogs
.DESCRIPTION
   Get-ADSSPRLogs retrieves the Azure AD Self Service Password Reset event logs
   from the domain controller. 
.PARAMETER Computername
  Gets events from the event logs on the specified computer. By default, it will 
  run against the local computer.

.PARAMETER MaxEvents
 Specifies the maximum number of events that Get-ADSSPRLogs returns. Enter an
 integer. The default is to return all the events in the logs.

.PARAMETER Reference
 The reference parameter can be used to search for events that have a particular
 TrackingID or username referenced within the Event message. 

 .EXAMPLE
   Get-ADSSPRLogs -Computername S2DC1

   Lists all PasswordResetService events from the specified computer

 .EXAMPLE
   Get-ADSSPRLogs -Computername S2DC1 -MaxEvents 10

   Only lists the last 10 PasswordResetService events from the specified computer

 .EXAMPLE
   Get-ADSSPRLogs -Computername S2DC1 -Reference "49545e06-10d9-4596-bc51-99cbdc4a61e6"

   Lists all events with the specified TackingID. The TrackingID is the same as the 
   CorrelationId that is shown in the Azure Audit log. 

 .EXAMPLE
   Get-ADSSPRLogs -Computername S2DC1 -Reference "someone@company.com"

   Lists all events related to the referenced UserPrincipalName
#>

    [CmdletBinding()]
    Param
    (
        # The computername of the domain controller
        [Parameter(ValueFromPipeline)]
		[string]$ComputerName = $env:ComputerName,
        [Parameter(ValueFromPipeline)]
		[int]$MaxEvents,
        [Parameter(ValueFromPipeline)]
		[string]$Reference
    )

    Begin
    {
        # Self Service Password Log
        $SSPRLog = @{
        LogName = "Application"
        ProviderName = "PasswordResetService"
        }
    }
    Process
    {
        Try{
            If ($MaxEvents)
            {
                $ADSSPREvents = Get-WinEvent -ComputerName $ComputerName -FilterHashtable $SSPRLog -MaxEvents $MaxEvents
            }
            Else
            {
                $ADSSPREvents = Get-WinEvent -ComputerName $ComputerName -FilterHashtable $SSPRLog
            }
        }
        Catch{
        ## Write a warning to the console with the message thrown
        Write-Warning $_.Exception.Message
		}
    }
    End
    {
        If ($Reference)
        {
            Write-Verbose "Displaying all events that contain $Reference"
            $ADSSPREvents | Where-Object {$_.Message -like "*$Reference*"}
        }
        Else
        {
            $ADSSPREvents
        }
    }
}


