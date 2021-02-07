# Retrieve the Applocker Policy Settings 
$AppLockerGPOName = "Workplace-P-AppLocker-CMP"
$AppLockerGPOSettings = Get-GPO -Name "$AppLockerGPOName" | Select-Object *
$AppLockerPolicy = Get-AppLockerPolicy -Domain -Ldatp "LDAP:// $($$AppLockerGPOSettings.Path)"

#Executable to test
$TestFile = "C:\Temp\Testme.exe" 
# Test Impact
Test-AppLockerPolicy -PolicyObject $AppLockerPolicy -Path $TestFile -User corp.net\tina
