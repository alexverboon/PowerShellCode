
#https://blog.kloud.com.au/2018/07/19/measure-o365-atp-safe-attachments-latency-using-powershell/

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking


$RecipientAddress = 'oadmin@verboon.org';
$Messages = Get-MessageTrace -RecipientAddress $RecipientAddress -StartDate (Get-Date).AddHours(-1) -EndDate (get-date) 

<#
$details1 = Get-MessageTraceDetail -MessageTraceId "ce879179-eb01-4dcc-4acd-08d628547df6" -RecipientAddress $RecipientAddress | Sort-Object Date
$details2 = Get-MessageTraceDetail -MessageTraceId "1e37fc9e-f1ef-4149-9acc-08d628576371" -RecipientAddress $RecipientAddress | Sort-Object Date
$details3 = Get-MessageTraceDetail -MessageTraceId "77d39a9b-96e7-44bc-bcb5-08d6285888c6" -RecipientAddress $RecipientAddress | Sort-Object Date
$details4 = Get-MessageTraceDetail -MessageTraceId "d3f063b3-50cd-4a7e-f8d4-08d6285bef99" -RecipientAddress $RecipientAddress | Sort-Object Date
#>
ForEach ($msg in $Messages)
{
    Get-MessageTraceDetail -MessageTraceId $($msg.MessageTraceId).Guid -RecipientAddress $RecipientAddress | Select-Object * | Sort-Object Date 
    #Event,Action,Detail,date | Sort-Object Date 
    Write-Host "---------------------------------------------" -ForegroundColor Yellow
}


