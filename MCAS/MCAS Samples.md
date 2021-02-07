# MCAS Samples

## Alerts

# Get MCAS Alerts
Get-MCASAlert -Credential $mcasconnect | Select-Object Description

# Get User Activity

$Activities = Get-MCASActivity -Credential $mcasconnect -UserName 'joe@contoso.com' -ResultSetSize 50
$result = ForEach($act in $Activities)
 {
    [PSCustomObject] [ordered]@{
	AppName = $act.AppName
        Device = $act.device.clientip
        Country = $act.location.countryCode
        City = $act.location.city
        region = $act.location.region
	CreatedDateTime =  ([datetimeoffset]::FromUnixTimeMilliseconds(1000 * ((($act.created).toString()).substring(0,10) + "." + (($act.created).toString()).substring(10,3)))).DateTime
    }
}
$result

#MCAS Configuration
Get-MCASConfiguration -Credential $mcasconnect

#MCAS App Info, the cmdlet validates the AppNames
Get-MCASAppId -AppName Office_365
# 11161

Get-MCASAppInfo -AppId 11161 | Select-object Name, Description



#
$n = 11161
$apps = while ($n  -ne  11500)
{
    Get-MCASAppInfo -Credential $mcasconnect -AppId $n | Select-Object Name, appid,childapps,app_level
 Start-Sleep -Seconds 1
$n++
}



# File Accessed 
Get-MCASActivity -EventTypeName "EVENT_CATEGORY_ACCESS_FILE" -Credential $mcasconnect







