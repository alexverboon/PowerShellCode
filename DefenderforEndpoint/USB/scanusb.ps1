function UsbMountWatcher {
    $alarm = New-Object System.Management.EventQuery
    $alarm.QueryString = "SELECT * FROM Win32_VolumeChangeEvent WHERE EventType = 2"
    New-Object System.Management.ManagementEventWatcher $alarm
}
$pathtompcmdrun = $env:PROGRAMFILES + "\Windows Defender\MpCmdRun.exe"
$watcher = UsbMountWatcher
while ($true) {
    $event = $watcher.WaitForNextEvent()
    $driveletter = $event.Properties["DriveName"].Value.ToString() + "\"
    &$pathtompcmdrun "-Scan" "-File" $driveletter "-DisableRemediation"
    Write-Output $LASTEXITCODE
}
$watcher.Stop()
