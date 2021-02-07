
$mcastoken = ""
$mcasurl = "avmtplab.eu2.portal.cloudappsecurity.com"
#$mcasconnect = Connect-PSMCAS -MCASUrl $mcasurl -MCASToken $mcastoken
Get-MCASCredential -TenantUri "avmtplab.eu2.portal.cloudappsecurity.com"


## Apps
# Get all EventTypes
(Get-MCASActivity -AppName Office_365 | Group-Object EventTypeName).Name

# App Grant Consent
Get-MCASActivity -EventTypeName "EVENT_CATEGORY_GRANT_CONSENT"


# Get all EventTypes Values
(Get-MCASActivity -AppName Office_365 | Group-Object EventTypeValue).Name
# Get all Description_Ids
(Get-MCASActivity -AppName Office_365 | Group-Object Description_id).Name




## Users
# Get all EventTypes
(Get-MCASActivity -UserName "jane@contoso.com" | Group-Object eventTypeName).Name
# Get all EventTypes Values
(Get-MCASActivity -UserName oadmin@contoso.com | Group-Object EventTypeValue).Name
# Get all Description_Ids
(Get-MCASActivity -UserName oadmin@contoso.com | Group-Object Description_id).Name


## Devices
# Get all EventTypes
(Get-MCASActivity -DeviceType Desktop | Group-Object eventTypeName).Name
# Get all EventTypes Values
(Get-MCASActivity -DeviceType Desktop | Group-Object EventTypeValue).Name
# Get all Description_Ids
(Get-MCASActivity -DeviceType Desktop | Group-Object Description_id).Name

## AdminEvents
# Get all EventTypes
(Get-MCASActivity -AdminEvents | Group-Object eventTypeName).Name
# Get all EventTypes Values
(Get-MCASActivity -AdminEvents | Group-Object EventTypeValue).Name
# Get all Description_Ids
(Get-MCASActivity -AdminEvents | Group-Object Description_id).Name

# File Accessed 
Get-MCASActivity -EventTypeName "EVENT_CATEGORY_ACCESS_FILE" -Credential $mcasconnect

# Countries
$countries = Get-MCASActivity -CountryCodePresent | Select-Object -ExpandProperty Location
$countries | Group-Object City

# Stuff with a particular file
$fileactivity = Get-MCASActivity -FileID "ff9c1544-77ee-43c0-887d-73e1da4708b6|10e77f7e-8c8e-4334-943a-82b363efad86"
$fileactivity | Select-Object -ExpandProperty User

