

#------------------------------------------------------------------------------
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR 
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#
#------------------------------------------------------------------------------
# Author: Eyal Doron 
# Version: 1.2 
# Last Modified Date: 19/12/2017  
# Last Modified By: eyal@o365info.com
# Web site: o365info.com
# Article name: Get the value of the DKIM record for a Domain, using PowerShell | Office 365 | Part 7#10
# Article URL: http://o365info.com/get-the-value-of-the-dkim-record-for-a-domain-using-powershell-office-365-part-7-10/
# sn -AA0016789DFSdAVXDSXCV
#------------------------------------------------------------------------------
# Hope that you enjoy it ! 
# And, may the force of PowerShell will be with you  :-)
# ------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# PowerShell Functions
#------------------------------------------------------------------------------

function checkConnection 
{
		$a = Get-PSSession
		if ($a.ConfigurationName -ne "Microsoft.Exchange")
		{
			
			write-host     'You are not connected to Exchange Online PowerShell ;-(         ' 
			write-host      'Please connect using the Menu option 1) Login to Office 365 + Exchange Online using Remote PowerShell        '
			#Read-Host "Press Enter to continue..."
			Add-Type -AssemblyName System.Windows.Forms
			[System.Windows.Forms.MessageBox]::Show("You are not connected to Exchange Online PowerShell ;-( `nSelect menu 1 to connect `nPress OK to continue...", "o365info.com PowerShell script", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
			Clear-Host
			break
		}
}



Function Disconnect-ExchangeOnline {Get-PSSession | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"} | Remove-PSSession}


Function Set-AlternatingRows {
       <#
       
       #>
    [CmdletBinding()]
       Param(
             [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]$Line,
       
           [Parameter(Mandatory=$True)]
             [string]$CSSEvenClass,
       
        [Parameter(Mandatory=$True)]
           [string]$CSSOddClass
       )
       Begin {
             $ClassName = $CSSEvenClass
       }
       Process {
             If ($Line.Contains("<tr>"))
             {      $Line = $Line.Replace("<tr>","<tr class=""$ClassName"">")
                    If ($ClassName -eq $CSSEvenClass)
                    {      $ClassName = $CSSOddClass
                    }
                    Else
                    {      $ClassName = $CSSEvenClass
                    }
             }
             Return $Line
       }
}




#------------------------------------------------------------------------------
# Genral
#------------------------------------------------------------------------------
$FormatEnumerationLimit = -1
$Date = Get-Date
$Datef = Get-Date -Format "\Da\te dd-MM-yyyy \Ti\me H-mm" 
#------------------------------------------------------------------------------
# PowerShell console window Style
#------------------------------------------------------------------------------

$pshost = get-host
$pswindow = $pshost.ui.rawui

	$newsize = $pswindow.buffersize
	
	if($newsize.height){
		$newsize.height = 3000
		$newsize.width = 150
		$pswindow.buffersize = $newsize
	}

	$newsize = $pswindow.windowsize
	if($newsize.height){
		$newsize.height = 50
		$newsize.width = 150
		$pswindow.windowsize = $newsize
	}

#------------------------------------------------------------------------------
# HTML Style start 
#------------------------------------------------------------------------------
$Header = @"
<style>
Body{font-family:segoe ui,arial;color:black; }

H1 {font-size: 26px; font-weight:bold;width: 70% text-transform: uppercase; color: #0000A0; background:#2F5496 ; color: #ffffff; padding: 10px 10px 10px 10px ; border: 3px solid #00B0F0;}
H2{ background:#F2F2F2 ; padding: 10px 10px 10px 10px ; color: #013366; margin-top:35px;margin-bottom:25px;font-size: 22px;padding:5px 15px 5px 10px; }

.TextStyle {font-size: 26px; font-weight:bold ; color:black; }

TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 5px;border-style: solid;border-color: #d1d3d4;background-color:#0072c6 ;color:white;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}

.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }



.note0
{width: 50%;padding:15px 15px 15px 15px;font-size: 1.1em;margin-top:15px;margin-bottom:45px;border-top: 3px dashed #2F5496;border-bottom: 3px dashed #2F5496;background: #F2F2F2;line-height: 1.6;
}


.o365info {height: 90px;padding-top:5px;padding-bottom:5px;margin-top:20px;margin-bottom:20px;border-top: 3px dashed #002060;border-bottom: 3px dashed #002060;background: #00CCFF;font-size: 120%;font-weight:bold;background:#00CCFF url(http://o365info.com/wp-content/files/PowerShell-Images/o365info120.png) no-repeat 680px -5px;
}

</style>

"@

$EndReport = "<div class=o365info>  This report was created by using <a href= http://o365info.com target=_blank>o365info.com</a> PowerShell script </div>"


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Exchange Online DKIM Settings PowerShell - Script menu
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

$Loop = $true
While ($Loop)
{
    write-host 
    write-host +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    write-host   "Exchange Online DKIM Settings PowerShell - Script menu"
    write-host +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    write-host
	write-host -ForegroundColor white  '----------------------------------------------------------------------------------------------' 
    write-host -ForegroundColor white  -BackgroundColor DarkCyan     'Connect Exchange Online using Remote PowerShell        ' 
    write-host -ForegroundColor white  '----------------------------------------------------------------------------------------------' 
	write-host -ForegroundColor Yellow ' 1) Login to Exchange Online using Remote PowerShell ' 
    write-host
	write-host -ForegroundColor green '----------------------------------------------------------------------------------------------' 
    write-host -ForegroundColor white  -BackgroundColor DarkGreen   'SECTION A: View and Export information about DKIM DNS records settings      ' 
    write-host -ForegroundColor green '----------------------------------------------------------------------------------------------' 
    write-host                                              ' 2) View and Export information about the DKIM CNAME record synatx for a specific Domain name '
	write-host                                              ' 3) View and Export information about the DKIM CNAME record synatx for a All Domain names '
	write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host -ForegroundColor white  -BackgroundColor DarkRed   'SECTION B: Disable DKIM signing policy  ' 
    write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host                                              ' 4) Disable the DKIM signing policy for a specific Domain name '
	write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue   'SECTION C: Enable DKIM signing policy  ' 
    write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host                                              ' 5) Enable the DKIM signing policy for a specific Domain name  '
    write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue   'SECTION D: Create DKIM selectors configuration in Exchange Online   ' 
    write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
    write-host                                              ' 6) Enable the DKIM signing policy for a specific Domain name  '
	write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 

    write-host -ForegroundColor white  -BackgroundColor DarkCyan 'End of PowerShell - Script menu ' 
    write-host -ForegroundColor green  '----------------------------------------------------------------------------------------------' 
	write-host -ForegroundColor Yellow            "20)  Disconnect PowerShell session" 
    write-host
    write-host -ForegroundColor Yellow            "21) Exit the PowerShell script menu (Or use the keyboard combination - CTRL + C)" 
    write-host

    $opt = Read-Host "Select an option [1-21]"
    write-host $opt
    switch ($opt) 


{



#===============================================================================================================
# Step -00 | Connect to Windows Azure Active Directory  & Exchange Online using Remote PowerShell
#===============================================================================================================

		

	
1
{

#####################################################################
# Connect Exchange Online using Remote PowerShell
#####################################################################

# information 
clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host  -ForegroundColor white		Information                                                                                          
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------                                                                
write-host  -ForegroundColor white  	'To be able to use the PowerShell menus in the script,  '
write-host  -ForegroundColor white  	'you will need to Login to Exchange Online using Remote PowerShell. '
write-host  -ForegroundColor white  	'In the credentials windows that appear,   '
write-host  -ForegroundColor white  	'provide your Office 365 Global Administrator credentials.  '
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'$UserCredential = Get-Credential '
write-host  -ForegroundColor Cyan    	'$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection '
write-host  -ForegroundColor Cyan    	'Import-PSSession $Session '
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
write-host
write-host

Disconnect-ExchangeOnline 
# Specify your administrative user credentials on the line below 

$user = “Provide credentials”

$UserCredential = Get-Credential -Credential $user

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session

#------------------------------------------------------------------------------
# Object Properties Array 
#------------------------------------------------------------------------------
# DKIM Domain name properties 
$global:Array1  = "Domain","Enabled"

$global:Array2  = "Domain","Selector1CNAME","Selector2CNAME"

}


		

#=========================================================================================
# SECTION A: View and Export information about DKIM DNS records settings
#=========================================================================================


2
{

##########################################################################
# View and Export information about the DKIM CNAME record synatx for a specific Domain name
##########################################################################

# information 
checkConnection

clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'This option will:  '
write-host  -ForegroundColor white  	'View and Export information about the DKIM CNAME record synatx for a specific Domain name '
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The export command will:   '
write-host  -ForegroundColor white  	'1. Export the required information to the following path =>' -NoNewline;Write-Host ' C:\INFO\DKIM Record settings  ' -ForegroundColor Cyan  
write-host  -ForegroundColor white  	'2. Save all of the exported information to diffrent file formats: TXT and HTML. '
write-host  -ForegroundColor white  	'Note - Be patient, the operation can take a long time. '
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'Get-DkimSigningConfig <Domain name> | FL *CNAME '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host

# User input	

write-host -ForegroundColor white	'User input '
write-host -ForegroundColor white	---------------------------------------------------------------------------- 
write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
write-host
write-host -ForegroundColor Yellow	"1.  Doamin name"  
write-host -ForegroundColor Yellow	"This is the name of the Domain for which you asking to get Information about DKIM DNS record syntax"   
write-host -ForegroundColor Yellow	"For example:  o365info.com"
write-host
$Domain  = Read-Host "Type the The Doamin name "
write-host
write-host


$DKIMSelector = Get-DkimSigningConfig $Domain 
$DKIMSelector.Selector1CNAME
$DKIMSelector.Selector2CNAME

$SelectorA = $DKIMSelector.Selector1CNAME
$SelectorB = $DKIMSelector.Selector2CNAME
					
$Selector1 = 
"<div class=note0>
1. The first part (the top part) of the CNAME record is:
<div class='TextStyle'> Selector1._domainkey </div>

</br>

2. The second part of the CNAME record is:
<div class='TextStyle'> $SelectorA </div>
</br>
<img src='http://o365info.com/wp-content/gallery/get-the-value-of-the-dkim-record-for-a-domain-using-powershell-office-365-part-7-10/Creating-CNAME-record-for-DKIM-in-Office-365-Selector1.domainkey-01-1.jpg'/>

</div>"


$Selector2 = "<div class=note0>
1. The first part (the top part) of the CNAME record is:
<div class='TextStyle'> Selector2._domainkey </div>
</br>

2. The second part of the CNAME record is:


<div class='TextStyle'> $SelectorB </div>


</br>
<img src='http://o365info.com/wp-content/gallery/get-the-value-of-the-dkim-record-for-a-domain-using-powershell-office-365-part-7-10/Creating-CNAME-record-for-DKIM-in-Office-365-Selector2.domainkey-02.jpg' />

</div>"


# Display Information about Audit settings

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about DKIM host names: "$Domain".ToUpper() 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array2	  | Out-String
write-host -------------------------------------------------------------------------------------------------

write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'To be able to create the required DNS records for your Office 365 DKIM implementation '
write-host  -ForegroundColor white  	'for the domain name $Domain   '
write-host  -ForegroundColor white  	'You will need to create 2 CNAME records.'
write-host  -ForegroundColor white  	'The syntax of the 2 CNAME records is: '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   CNAME record 1 -  "$Domain".ToUpper() 
write-host -------------------------------------------------------------------------------------------------
write-host  -ForegroundColor white  	'The first part (the “top” part) of the CNAME record is:'
write-host  -ForegroundColor Yellow  	'Selector1._domainkey   '
write-host  
write-host  -ForegroundColor white  	'The second part of the CNAME record is:'
write-host  -ForegroundColor Yellow  	$DKIMSelector.Selector1CNAME  
write-host -------------------------------------------------------------------------------------------------

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   CNAME record 2 -  "$Domain".ToUpper() 
write-host -------------------------------------------------------------------------------------------------
write-host  -ForegroundColor white  	'The first part (the “top” part) of the CNAME record is:'
write-host  -ForegroundColor Yellow  	'Selector1._domainkey   '
write-host  
write-host  -ForegroundColor white  	'The second part of the CNAME record is:'
write-host  -ForegroundColor Yellow  	$DKIMSelector.Selector2CNAME   
write-host -------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
# Create folders Structure that contain the exported information to TXT and HTML files
#---------------------------------------------------------------------------------------------------

$A20 =    "C:\INFO\DKIM Record settings"

#---------------------------------------------------------------------------------------------------
# Create the required folders in Drive C:
#---------------------------------------------------------------------------------------------------

write-host  -ForegroundColor white  	'Creating folder structure for storing information on C:\INFO\DKIM Record settings '	

if (!(Test-Path -path $A20))
{New-Item $A20 -type directory}

#---------------------------------------------------------------------------------------------------
# Export xxx to a files 
#---------------------------------------------------------------------------------------------------

write-host -ForegroundColor green  'Export  DKIM informaiton to a files - File Format - HTML + TEXT' 
write-host

###TXT####
Get-DkimSigningConfig $Domain | Format-list *CNAME | Out-File $A20\"information about the DKIM host name record for $Domain.txt" -Encoding utf8
##########

###HTML####
Get-DkimSigningConfig $Domain | Select-Object   Domain,Selector1CNAME,Selector2CNAME | ConvertTo-Html -head $Header -Body  "<H1>information about the DKIM host name record for $Domain   |  $Datef </H1>"  | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd | Out-File $A20\"information about the DKIM host name record for $Domain.htm"
Add-Content $A20\"information about the DKIM host name record for $Domain.htm" $Selector1
Add-Content $A20\"information about the DKIM host name record for $Domain.htm" $Selector2
Add-Content $A20\"information about the DKIM host name record for $Domain.htm" $EndReport
##########
#---------------------------------------------------------------------------------------------------


# End the Command
write-host
write-host
Read-Host "Press Enter to continue..."
write-host
write-host

}



3
{

##########################################################################
# View and Export information about the DKIM CNAME record synatx for a All Domain names
##########################################################################

# information 
checkConnection

clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'This option will:  '
write-host  -ForegroundColor white  	'View and Export information about the DKIM CNAME record synatx for a All Domain names  '
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The export command will:   '
write-host  -ForegroundColor white  	'1. Export the required information to the following path =>' -NoNewline;Write-Host ' C:\INFO\DKIM Record settings  ' -ForegroundColor Cyan  
write-host  -ForegroundColor white  	'2. Save all of the exported information to diffrent file formats: TXT and HTML. '
write-host  -ForegroundColor white  	'Note - Be patient, the operation can take a long time. '
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'Get-DkimSigningConfig | FL  Domain,Selector1CNAME,Selector2CNAME	 '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host

# Display Information about Audit settings

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about DKIM host names: "$Domain".ToUpper() 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig | Select-Object  $global:Array2 | Out-String
write-host -------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------
# Create folders Structure that contain the exported information to TXT and HTML files
#---------------------------------------------------------------------------------------------------

$A20 =    "C:\INFO\DKIM Record settings"

#---------------------------------------------------------------------------------------------------
# Create the required folders in Drive C:
#---------------------------------------------------------------------------------------------------

write-host  -ForegroundColor white  	'Creating folder structure for storing information on C:\INFO\DKIM\All Domains '	

if (!(Test-Path -path $A20))
{
New-Item $A20 -type directory
}

#---------------------------------------------------------------------------------------------------
# Export Information about DKIM DNS record syntax to files
#---------------------------------------------------------------------------------------------------

write-host -ForegroundColor green  'Export  DKIM informaiton to a files - File Format - HTML + TEXT' 
write-host

###TXT####
Get-DkimSigningConfig | Format-List *CNAME | Out-File $A20\"Information about the DKIM host name record for for ALL Domain names.txt" -Encoding utf8
##########

###HTML####
Get-DkimSigningConfig |  Select-Object  $global:Array2 | ConvertTo-Html -post $EndReport -head $Header -Body  "<H1>Information about the DKIM host name record for for ALL Domain names  |  $Datef </H1>"  | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd | Out-File $A20\"Information about the DKIM host name record for for ALL Domain names.htm"
##########

#---------------------------------------------------------------------------------------------------




#---------------------------------------------------------------------------------------------------
#
#---------------------------------------------------------------------------------------------------

###TXT####
Get-DkimSigningConfig | Format-List *CNAME | Out-File $A20\"Get-DkimSigningConfig for ALL Domain names.txt" -Encoding utf8
##########

###HTML####
Get-DkimSigningConfig | ConvertTo-Html -post $EndReport -head $Header -Body  "<H1>Get-DkimSigningConfig for ALL Domain names   |  $Datef </H1>"  | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd | Out-File $A20\"Get-DkimSigningConfig for ALL Domain names.htm"
##########

#---------------------------------------------------------------------------------------------------


#Section 5: End the Command
write-host
write-host
Read-Host "Press Enter to continue..."
write-host
write-host

}


#=========================================================================================
# SECTION B:  Disable DKIM signing policy
#=========================================================================================

4
{

##########################################################################
# Disable the DKIM signing policy for a specific Domain name 
##########################################################################

# information 
checkConnection

clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'This option will:  '
write-host  -ForegroundColor white  	'Disable the DKIM signing policy for a specific Domain name'
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'Set-DkimSigningConfig -Identity <Domain name> -Enabled $False '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host


# Display Information about DKIM settings for each existing Domain 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display Information about DKIM settings for each existing Domain
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig | Format-List  Domain  | Out-String
write-host -------------------------------------------------------------------------------------------------



# User input	

write-host -ForegroundColor white	'User input '
write-host -ForegroundColor white	---------------------------------------------------------------------------- 
write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
write-host
write-host -ForegroundColor Yellow	"1.  Doamin name" 
write-host -ForegroundColor Yellow	"This is the name of the Domain for which you asking to Disable DKIM signature"   
write-host -ForegroundColor Yellow	"For example:  o365info.com"
write-host
$Domain  = Read-Host "Type the The Doamin name "
write-host
write-host

# Display Information about DKIM settings for Specific Domain name  |=> BEFORE the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => BEFORE the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------

# PowerShell Command

Set-DkimSigningConfig -Identity $Domain -Enabled $False

# Display Information about DKIM settings for Specific Domain name | => AFTER the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => AFTER the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------

#Section 5: End the Command
write-host
write-host
Read-Host "Press Enter to continue..."
write-host
write-host

}



#=========================================================================================
# SECTION C:  Enable DKIM signing policy
#=========================================================================================

5
{

##########################################################################
# Enable the DKIM signing policy for a specific Domain name
##########################################################################

# information 
checkConnection

clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'This option will:  '
write-host  -ForegroundColor white  	'Enable the DKIM signing policy for a specific Domain name '
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'Set-DkimSigningConfig -Identity <Domain name> -Enabled $True '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host


# Display Information about DKIM settings for each existing Domain 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display Information about DKIM settings for each existing Domain
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig | Format-List  Domain  | Out-String
write-host -------------------------------------------------------------------------------------------------


# User input	

write-host -ForegroundColor white	'User input '
write-host -ForegroundColor white	---------------------------------------------------------------------------- 
write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
write-host
write-host -ForegroundColor Yellow	"1.  Doamin name" 
write-host -ForegroundColor Yellow	"This is the name of the Domain for which you asking to Enable DKIM signature"   
write-host -ForegroundColor Yellow	"For example:  o365info.com"
write-host
$Domain  = Read-Host "Type the The Doamin name "
write-host
write-host

# Display Information about DKIM settings for Specific Domain name  |=> BEFORE the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => BEFORE the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------


# PowerShell Command

Set-DkimSigningConfig -Identity $Domain -Enabled $True

# Display Information about DKIM settings for Specific Domain name | => AFTER the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => AFTER the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------

# End the Command
write-host
write-host
Read-Host "Press Enter to continue..."
write-host
write-host

}





#=========================================================================================
# SECTION D: Create DKIM selectors configuration in Exchange Online 
#=========================================================================================

6
{

##########################################################################
# Enable the DKIM signing policy for a specific Domain name
##########################################################################

# information 
checkConnection

clear-host

write-host
write-host
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                              
write-host  -ForegroundColor white		Introduction                                                                                          
write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
write-host  -ForegroundColor white  	'This option will:  '
write-host  -ForegroundColor white  	'Enable the DKIM signing policy for a specific Domain name'
write-host  -ForegroundColor white		------------------------------------------------------------------------------------------  
write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
write-host  -ForegroundColor Cyan    	'New-DkimSigningConfig -DomainNam <Domain name> -Enabled $True '
write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
write-host


# Display Information about DKIM settings for each existing Domain 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display Information about DKIM settings for each existing Domain
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig | Format-List  Domain  | Out-String
write-host -------------------------------------------------------------------------------------------------


# User input	

write-host -ForegroundColor white	'User input '
write-host -ForegroundColor white	---------------------------------------------------------------------------- 
write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
write-host
write-host -ForegroundColor Yellow	"1.  Doamin name" 
write-host -ForegroundColor Yellow	"This is the name of the Domain for which you asking to  Create DKIM selectors configuration in Exchange Online "   
write-host -ForegroundColor Yellow	"For example:  o365info.com"
write-host
$Domain  = Read-Host "Type the The Doamin name "
write-host
write-host

# Display Information about DKIM settings for Specific Domain name  |=> BEFORE the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => BEFORE the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------


# PowerShell Command

New-DkimSigningConfig -DomainName $Domain 

# Display Information about DKIM settings for Specific Domain name | => AFTER the update 

write-host
write-host -------------------------------------------------------------------------------------------------
write-host -ForegroundColor white  -BackgroundColor Blue   Display information about: "$Domain".ToUpper() policy => AFTER the update 
write-host -------------------------------------------------------------------------------------------------
Get-DkimSigningConfig $Domain | Select-Object  $global:Array1  | Out-String
write-host -------------------------------------------------------------------------------------------------

# End the Command
write-host
write-host
Read-Host "Press Enter to continue..."
write-host
write-host

}




#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Section END
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


#+++++++++++++++++++
# Step -05 Finish  
##++++++++++++++++++

	
20{

##########################################
# Disconnect PowerShell session  
##########################################


write-host -ForegroundColor Yellow Choosing this option will Disconnect the current PowerShell session 

Disconnect-ExchangeOnline 

write-host
write-host

#———— Indication ———————

if ($lastexitcode -eq 0)
{
write-host -------------------------------------------------------------
write-host "The command complete successfully !" -ForegroundColor Yellow
write-host "The PowerShell session is disconnected" -ForegroundColor Yellow
write-host -------------------------------------------------------------
}
else

{
write-host "The command Failed :-(" -ForegroundColor red

}

#———— End of Indication ———————


}




21
{

##########################################
# Exit  
##########################################


$Loop = $true
Exit
}

}


}
