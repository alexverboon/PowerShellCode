

Function Set-NetBiosEnabled
{
<#
.Synopsis
   Set-NetBiosEnabled
.DESCRIPTION
   Set-NetBiosEnabled Enables NetBIOS over TCP/IP on all IP enabled network adapters
   where NETBIOS is not already Enabled. 
   
.EXAMPLE
   Set-NetBiosEnabled
.NOTES
  v1, 14-12-2019, Alex Verboon, initial version

  https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/settcpipnetbios-method-in-class-win32-networkadapterconfiguration

#>
[CmdletBinding(SupportsShouldProcess)]
  Param()
  
  Begin{
      [int]$DisableValue = 0
  }
  Process{
        Try{
            $adapters = (Get-WmiObject -Class win32_networkadapterconfiguration -Filter "ipenabled = 'true'" -ErrorAction Stop)
            Foreach ($adapter in $adapters)
            {
                             Write-Host $adapter.TcpipNetbiosOptions
              If ($adapter.TcpipNetbiosOptions -ne 0)
              {
 
                  if ($PSCmdlet.ShouldProcess($adapter.Description,'Disabling NetBIOS over TCP/IP'))
                  {
                    $result = $adapter.settcpipnetbios($DisableValue)
                  }
              }
              Else
              {
                Write-host "NetBIOS is already Enabled on $($adapter.Description)"
              }
            }
        }
        Catch{
            $Error
        }
    }
    End{}
}


Set-NetBiosEnabled