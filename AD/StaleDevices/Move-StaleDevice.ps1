
function Move-StaleDevice
<#
.Synopsis
   Move-StaleDevice
.DESCRIPTION
   Move-StaleDevice moves the specified computer to the specified OU

   Use the Search-AD object to identify inactive devices
   Search-ADAccount -AccountInactive –ComputersOnly -TimeSpan 90

.PARAMETER ComputerDistinguishedName
    The DistinguishedName of the computer object to be moved

    CN=Server2016-01,OU=Datacenter,DC=corp,DC=net

.PARAMETER TargetOU
    The DistinguishedName name of the organizational unit in active directory where the computer object is moved to. 

    OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net

.EXAMPLE
   
   Move-StaleDevice -ComputerDistinguishedName "CN=Server2016-01,OU=Datacenter,DC=corp,DC=net" -TargetOU "OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net"

   This command moves the computer server2016-01 located in the OU Datacenter to the OU OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net"

.EXAMPLE
    
    $StaleDevices  = @(Search-ADAccount -AccountInactive –ComputersOnly -TimeSpan 90).DistinguishedName
    $output = ForEach($computer in $StaleDevices)
    {
        Move-StaleDevice -ComputerDistinguishedName "$computer" -TargetOU "OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net" 
    }
    $output
   

    ComputerName                                  TargetOU                                        MoveStatus
    ------------                                  --------                                        ----------
    CN=Server2016-01,OU=Datacenter,DC=corp,DC=net OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net Sucess    
    CN=Server2016-02,OU=Datacenter,DC=corp,DC=net OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net Sucess    
    CN=Server2019-01,OU=Datacenter,DC=corp,DC=net OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net Sucess    

    The above command provides an example of moviing several computer objects. 
  
.NOTES
    version 1.0, 20.10.2020, Alex Verboon
.COMPONENT
.ROLE
.FUNCTIONALITY
#>

{
    [CmdletBinding(SupportsShouldProcess=$true, 
                  ConfirmImpact='Medium')]
    Param
    (
        # Computer DistinguishedName
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerDistinguishedName,
        # Target OU where the device is moved to
        [Parameter(Mandatory=$false)]
        #[ValidateNotNull()]
        #[ValidateNotNullOrEmpty()]
        $TargetOU="OU=ServerDevices,OU=StaleDevices,DC=corp,DC=net"
    )

    Begin
    {
        Try {
            Import-Module ActiveDirectory -ErrorAction Stop -Verbose:$false
        } catch {
            Write-Error "Active Directory module failed to Import. Terminating the script. More details : $_"
        exit(1)
        }

        # Check if Active Directory Organizational Unit where the object is moved to exists
        If(!(Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$TargetOU'")) {
            Write-Error "Organizational Unit $TargetOU does not exist."
            Break
        }
    }
    Process
    {
        $Result = [System.Collections.ArrayList]::new()
        $movecount = 0
        if ($pscmdlet.ShouldProcess("$ComputerDistinguishedName", "Move object to $TargetOU"))
        {
            Try{
                Move-ADObject -Identity "$ComputerDistinguishedName" -TargetPath $TargetOU -Verbose
                $movecount++
                $MoveStatus="Sucess"
            }
            # Specified Computer object not found
            Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
            {
                $ErrorMessage = $Error[0] #.Exception.GetType().FullName
                Write-Error "Device $ComputerDistinguishedName not found: $ErrorMessage"
                $MoveStatus="Failed"
            }
            # Any other AD exception
            Catch [Microsoft.ActiveDirectory.Management.ADException]
            {
              $ErrorMessage = $Error[0] #.Exception.GetType() #.FullName
              write-Error $ErrorMessage
              $MoveStatus="Failed"
            }
            Catch{
                 $ErrorMessage = $Error[0] #.Exception.GetType().FullName
                 Write-Error "There was an error: $ErrorMessage"
                 $MoveStatus="Failed"
            }
            
            $object = [PSCustomObject]@{
            ComputerName = $ComputerDistinguishedName
            TargetOU     = $TargetOU
            MoveStatus   = $MoveStatus
            }
            [void]$Result.Add($object)
        }
        $Result
    }
    End
    {
    }
}





