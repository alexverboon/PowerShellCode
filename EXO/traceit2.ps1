
$startDate = (Get-Date -Hour 0 -Minute 0 -Second 0).AddDays(-1) 
$EndDate = (Get-Date -Hour 23 -Minute 59 -Second 59).AddDays(-1)
$Receipientemail = "*@basevision.ch"

#$allmsg = Get-MessageTrace -RecipientAddress $Receipientemail -StartDate $startDate -EndDate $EndDate | Select-Object * | Where-Object {$_.status -ne "Delivered"}

$allmsg = Get-MessageTrace -RecipientAddress $Receipientemail -StartDate $startDate -EndDate $EndDate | Select-Object * # | Where-Object {$_.status -ne "Delivered"}
$inforesult = @()
ForEach ($msg in $allmsg)
{
    #Write-Host $msg.Subject -ForegroundColor Green
    $detail = (Get-MessageTraceDetail -MessageTraceId $msg.MessageTraceId -RecipientAddress $msg.RecipientAddress) # -StartDate $startDate -EndDate $EndDate)
    $inforesult = $inforesult + $detail
}

$inforesult | Select Messageid, Date,Event, Detail, Data


##############################

$startDate = (Get-Date).AddDays(-15)
$EndDate = (Get-Date)

$atptraffice = Get-MailTrafficATPReport -StartDate $startDate -EndDate $EndDate | Select-Object *

#Get-MailTrafficReport -StartDate $startDate -EndDate $EndDate | Select-Object *

Get-MailDetailATPReport -StartDate $startDate -EndDate $EndDate | Select-Object *
$tls = $inforesult | Select-Object Detail,data | Where-Object {$_.detail -like "Message received by:*"}

$b = [xml]$tls