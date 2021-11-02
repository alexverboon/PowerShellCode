<#
.Synopsis
   Install-MMAAgent
.DESCRIPTION
   Install-MMAAgent installs the prerequisites to onboard Windows Server 2008-R2/2012-R2 and 2016 into MDE
   To onbboard Windows Server 2019 use the onboarding script that can be downloaded from the MDE portal. 

   https://docs.microsoft.com/en-us/azure/azure-monitor/agents/agent-windows

.NOTES
    v1.0, 02.05.2021, alex verboon
#>
[CmdletBinding()]
Param()

Begin{
$SourcePath = $PSScriptRoot
        Function Get-TimeStamp{
            Get-Date -Format "ddMMyyyy:HHmmss"
        }
    $DateTimeStamp = (Get-Date -Format "ddMMyyyy_HHmm")
    $InstallLogFile = "$SourcePath\MDEInstall_$DateTimeStamp.LOG"
    Write-Output "$(Get-TimeStamp) Starting MDE Enablement" | out-file $InstallLogFile -Append

    If (-not (Test-Path "$SourcePath\MMA" -PathType Container)){
        Write-Warning "$SourcePath\MMA Source Directory missing"
    }
    If (-not(Test-Path "$SourcePath\SCEP" -PathType Container)){
        Write-Warning "$ourcePath\SCEP Source Directory missing"
    }


    # -------------------------------------------------------------- #
    # SCEP Agent for Server 2008-R2 and 2012-R2 Parmaeters
    # -------------------------------------------------------------- #
    $SCEPAgentSetup = "$SourcePath\scep\SCEPInstall.exe"
    $SCEPAgentUpdate = "$SourcePath\scep\scepinstall_update_KB3209361.exe"
    $ScepParameters = "/s"
    $ScepUpdateParameters = "/s"

    # -------------------------------------------------------------- #
    # MMA Agent Parameters
    # -------------------------------------------------------------- #
    $MMAProxy = "https://proxy.contoso.com:30443"
    $SetMMAProxy = $false
    $MMAAgentSetup = "$SourcePath\MMA\SETUP.EXE"
    $OPSINSIGHTS_WS_ID = ""
    $OPSINSIGHTS_WS_KEY = ""

}

Process{
    Write-Output "$(Get-TimeStamp) Starting SCEP Installation" | out-file $InstallLogFile -Append
    $OSVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
    Write-Output "$(Get-TimeStamp) OS Version [$OSVersion]" | out-file $InstallLogFile -Append


    If($OSVersion -like "*2012 R2*"){
        Write-Host "Running on Windows Server [$OSVersion]"
        Write-Host "Installing SCEP Agent" -ForegroundColor Green
        Start-Process -FilePath $SCEPAgentSetup -ArgumentList $ScepParameters -NoNewWindow 
        $processNameToWaitForExit = 'SCEPInstall'
        do
        {
            Start-Sleep -Seconds 3
        } while (Get-Process -Name $processNameToWaitForExit -ErrorAction SilentlyContinue)
    
        Write-Host "Installing SCEP Agent update" -ForegroundColor Green
        Start-Process -FilePath $SCEPAgentUpdate -ArgumentList $ScepUpdateParameters -NoNewWindow 
        do
        {
          Start-Sleep -Seconds 3
        } while (Get-Process -Name $processNameToWaitForExit* -ErrorAction SilentlyContinue)
    }
    Else
    {
        Write-Host "Running on Windows Server [$OSVersion] skipping SCEP Agent Installation."
    }


    # -------------------------------------------------------------- #
    # MMA Agent 
    # -------------------------------------------------------------- #
    Write-Output "$(Get-TimeStamp) Starting MMA Installation" | out-file $InstallLogFile -Append
    If($OSVersion -like "*2012 R2*" -or $OSVersion -like "*2016*"){
        Write-Host "Installing MMA Agent" -ForegroundColor Green

        $parameters = '/Qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=' + $OPSINSIGHTS_WS_ID + ' OPINSIGHTS_WORKSPACE_KEY=' + $OPSINSIGHTS_WS_KEY + ' AcceptEndUserLicenseAgreement=1'
        Start-Process -FilePath $MMAAgentSetup -ArgumentList $parameters -wait -NoNewWindow

        If ($MMAProxy -eq $true){
            Write-Host "Set MMA Agent Proxy to $MMAProxy" -ForegroundColor Green
        
                Function Set-MMAProxy{   
                 param($ProxyDomainName)        
                # First we get the Health Service configuration object. We need to determine if we
                #have the right update rollup with the API we need. If not, no need to run the rest of the script.
                $healthServiceSettings = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
                $proxyMethod = $healthServiceSettings | Get-Member -Name 'SetProxyInfo'
                if (!$proxyMethod)
                {
                    Write-Output 'Health Service proxy API not present, will not update settings.'
                    return
                }
                Write-Output "Clearing proxy settings."
                $healthServiceSettings.SetProxyInfo('', '', '')

                Write-Output "Setting proxy to $ProxyDomainName with proxy username $ProxyUserName."
                $healthServiceSettings.SetProxyInfo($ProxyDomainName,"","")
            }
            Set-MMAProxy -ProxyDomainName $MMAProxy
        }
        Else{
            Write-Host "No MMA Proxy specified" -ForegroundColor Green
        }
    }
    Else{
        Write-Host "Running on Windows Server [$OSVersion] skipping MMA Agent Installation."
    }

    Write-Output "$(Get-TimeStamp) MDE Enablement completed" | out-file $InstallLogFile -Append
    }

End{}


