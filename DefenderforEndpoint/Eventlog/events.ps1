
(Get-WinEvent -ListProvider "Microsoft-Windows-Windows Defender").events | Format-Table id, description -AutoSize            

$EventFilter = @{
    ID = 1000,1001
    ProviderName = "Microsoft-Windows-Windows Defender"
}
Get-WinEvent -FilterHashtable $EventFilter | format-table -autosize


