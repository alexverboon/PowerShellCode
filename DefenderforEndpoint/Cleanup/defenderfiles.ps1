
# Defender ATP Service
$service = Get-WmiObject win32_service | Select-Object * |  where name -Like "*Sense*"
write-host "Name: $($service.Caption)"
Write-host "ServiceName: $($service.Name)"
write-host "Path: $($service.PathName)"

<#
Name: Windows Defender Advanced Threat Protection Service
ServiceName: Sense
Path: "C:\Program Files\Windows Defender Advanced Threat Protection\MsSense.exe"
#>


# Defender Service
$service = Get-WmiObject win32_service | Select-Object * |  where name -Like "*WinDefend*"
write-host "Name: $($service.Caption)"
Write-host "ServiceName: $($service.Name)"
write-host "Path: $($service.PathName)"

<#
Name: Microsoft Defender Antivirus Service
ServiceName: WinDefend
Path: "C:\ProgramData\Microsoft\Windows Defender\platform\4.18.2008.9-0\MsMpEng.exe"
#>


# Connected User Experience
$service = Get-WmiObject win32_service | Select-Object * |  where name -Like "*DiagTrack*"
write-host "Name: $($service.Caption)"
Write-host "ServiceName: $($service.Name)"
write-host "Path: $($service.PathName)"
<#
Name: Connected User Experiences and Telemetry
ServiceName: DiagTrack
Path: C:\WINDOWS\System32\svchost.exe -k utcsvc -p
#>


#Defender Executables
$defenderfiles = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows Defender\Platform" -Filter "*.exe" -Recurse
$defenderfiles | Select-Object Fullname

<#
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\ConfigSecurityPolicy.exe
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\MpCmdRun.exe            
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\MpDlpCmd.exe            
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\MsMpEng.exe             
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\NisSrv.exe              
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2007.8-0\X86\MpCmdRun.exe        
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\ConfigSecurityPolicy.exe
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\MpCmdRun.exe            
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\MpDlpCmd.exe            
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\MsMpEng.exe             
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\NisSrv.exe              
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2008.9-0\X86\MpCmdRun.exe    
#>


#Defender ATP Executables
<#
"C:\Program Files\Windows Defender Advanced Threat Protection\MsSense.exe"
"C:\Program Files\Windows Defender Advanced Threat Protection\SenseCncProxy.exe"
"C:\Program Files\Windows Defender Advanced Threat Protection\SenseIR.exe"
"C:\Program Files\Windows Defender Advanced Threat Protection\SenseSampleUploader.exe"
#>




