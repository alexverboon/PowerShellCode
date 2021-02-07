
# 1. download the script
# 	https://gallery.technet.microsoft.com/Ignite-2016-Slidedeck-and-296df316#content

# 2. Open PowerShell prompt (not ISE)

# 3. Adjust paths below for script location and output directory 

# 4. Run the below command to get a list of all sessions

$allsessions = C:\dev\Private\PowerShellSnippets\Ignite\Get-EventSession.ps1 -InfoOnly
# note this creates a session cache file that is valid for 1 day, the file is located in the script folder "Ignite-Sessions.cache"

# Select the sessons to download
$Selections = $allsessions | Select-Object SessionCode,Title | Out-GridView -OutputMode Multiple
ForEach ($session in $Selections)
{
    write-host "Retrieving "$($session).SessionCode""
    C:\dev\Private\PowerShellSnippets\Ignite\Get-EventSession.ps1 -ScheduleCode $($session).SessionCode -DownloadFolder "C:\Data\ignite" 
}





