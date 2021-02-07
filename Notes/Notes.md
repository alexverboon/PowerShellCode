
https://github.com/OfficeDev/MCCA


https://www.cyberdrain.com/monitoring-with-powershell-monitoring-legacy-authentication-logons/?utm_source=rss&utm_medium=rss&utm_campaign=monitoring-with-powershell-monitoring-legacy-authentication-logons






# ignatureDownloadCustomTask
https://www.powershellgallery.com/packages/SignatureDownloadCustomTask/1.4

	# ORCA
	https://office365itpros.com/2019/11/14/orca-checks-office365-atp-settings/

# HAWK
https://github.com/Canthv0/hawk

# Defender ASR
https://www.powershellgallery.com/packages/DefenderASR/0.0.2

# Defender maps
https://github.com/alexverboon/DefenderMAPS

# PowerSTIG
https://www.powershellgallery.com/packages/PowerSTIG/4.2.0

Office-365-Password-Spray
https://github.com/nickvangilder/Office-365-Password-Spray

DomainPasswordSpray
https://github.com/dafthack/DomainPasswordSpray

mtp 
https://github.com/microsoft/MTP-AHQ

LAPS
https://www.powershellgallery.com/packages/MrAToolbox/1.2.0/Content/Test-LapsCompliance.ps1

password spray
https://github.com/dafthack/MSOLSpray


# app crashes
Get-WinEvent -FilterHashtable @{'providername' = 'Windows Error Reporting';starttime=(Get-Date).AddDays(-7);Id=1001 } | Select TimeCreated,@{n='App';e={$_.Properties[5].value}}|Group-Object -Property App|Select-Object -Property Name,Count|Sort-Object -Property Count -Descending


https://github.com/microsoft/microsoft-defender-atp-manageability/blob/ece9933cf35c59af748a36ca1ed2311546cbc1d2/RestoreQuarantinedFile-NoOutput.ps1


https://github.com/jeremyts/ActiveDirectoryDomainServices/tree/5174f8075a67f94a7da5eec617d84d4464f98c44/Audit

https://yonileibowitz.github.io/kusto.blog/blog-posts/jakh.html

https://github.com/sevagas/WindowsDefender_ASR_Bypass-OffensiveCon2019

https://www.elastic.co/guide/en/siem/guide/7.8/prebuilt-rules.html

https://github.com/anthonws/MDATP_PoSh_Scripts?files=1

https://call4cloud.nl/2020/07/along-came-mcas-automation/

https://github.com/AlexFilipin/ConditionalAccess/wiki#quick-start

https://github.com/rod-trent/SentinelKQL

https://github.com/AzureAD/IdentityProtectionTools

https://github.com/swisscom/PowerSponse
