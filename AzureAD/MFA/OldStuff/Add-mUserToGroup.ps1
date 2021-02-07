
function Add-mUserToGroup
{
<#
.Synopsis
   Add-mUserToGroup
.DESCRIPTION
   Add-mUserToGroup adds one or more Active Directory users from an input file to the specified
   Active Directory group. 

.PARAMETER InputFile
  A txt input file that contains a list of users in the format of the users UserPrincipalName
 
   john.monroe@company.com
   jane.keen@company.com
   tom.wayne@company.com

.PARAMETER UserPrincipalName
 The UserPrincipalName of the user to add to the group. User this cmdlet to add a single user to a group
 without using an input file

.PARAMETER Group
 The Active Directory Group to add users

.EXAMPLE
   Add-mUserToGroup -InputFile c:\data\userlist.txt -Group MTG_MFA_ROLLOUT_TEST

   The above command reads the userprincipalnames from the userlist.txt and adds
   each user into the Active Directory group MTG_MFA_ROLLOUT_TEST 

.EXAMPLE
   Add-mUserToGroup -UserPrincipalName jane@verboon.org -Group MTG_MFA_ROLLOUT_TEST 

   The above command adds jane to the specified group

.EXAMPLE
   Add-mUserToGroup -InputFile c:\data\userlist.txt -Group MTG_MFA_ROLLOUT_TEST -whatif
   
   The above command only shows the users that would be added, but does not perform the 
   actual task of adding users to the specified group.

.NOTES
    v1.0, 01.04.2020, Alex Verboon
#>
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  ConfirmImpact='Medium')]
    Param
    (
        # Input file with list of users (UserPrincipalName)
        [Parameter(Mandatory=$true, 
                   Position=0,
                   ParameterSetName='InputFile')]
        [ValidateNotNullOrEmpty()]
        [string]$InputFile,

        # Active Directory User 
           [Parameter(Mandatory=$true, 
                   Position=0,
                   ParameterSetName='User')]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        # Active Directory Group 
           [Parameter(Mandatory=$true, 
                   Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$Group
    )

    Begin
    {
        $UserList = $null




        # Check if input file is valid
        If($InputFile)
        {
            If (Test-Path -Path $InputFile -PathType Leaf)
            {
                $UserList = Get-Content -Path $InputFile 
                Write-Verbose "InputFile: $InputFile"
            }
            Else
            {
                Write-Error "Specified file $InputFile does not exist"
                Break
            }
        }
        ElseIf($UserPrincipalName)
        {
         
                Write-Verbose "Check if user exists"
                $ADUser = @(Get-ADUser -Filter "UserPrincipalName -eq '$UserPrincipalName'" -Properties * -ErrorAction Stop)
                If ([string]::IsNullOrEmpty($ADUser))
                {
                    Write-Error "User: $UserPrincipalName does not exist"
                }
                Else
                {
                 $UserList = @($UserPrincipalName)
                 Write-Verbose "AD User: $UserPrincipalName"
                }
        }


       



        If ($Group)
        {
            Try{
                $ADGroup = Get-ADGroup -Identity "$Group" -ErrorAction stop
                Write-Verbose "AD Group: $Group"
            }
            Catch{
                Write-Error "Group $Group does not exist"
                Break
            }
        }
     }
    Process
    {
            ForEach ($user in $UserList)
            {
                Write-Verbose "Processing user $user"
                if ($pscmdlet.ShouldProcess("$User", "Adding user to group $Group"))
                {
                    $UserToAdd = Get-ADUser -Filter "UserPrincipalName -eq '$user'"
                    If([string]::IsNullOrEmpty($UserToAdd))
                    {
                        Write-Warning "User $user not found"
                    }
                    Else
                    {
                        Add-ADGroupMember -Identity $ADGroup -Members $UserToAdd
                    }
               }
            }
    }
    End
    {

    }
}












