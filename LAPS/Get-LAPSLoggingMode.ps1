

function Get-LAPSLoggingMode
{
    <#
    .SYNOPSIS
        Get-LAPSLoggingMode

    .DESCRIPTION
        Get-LAPSLoggingMode retrieves the ExtensionDebugLevel status from the LAPS Client Side Extension. 

        Possible values are:

        0	Silent mode; log errors only
        1	Log Errors and warnings
        2	Verbose mode, log everything

    .PARAMETER Computername
    Specifies the computers on which the command runs. The default is the local computer.
    When you use the ComputerName parameter, Windows PowerShell creates a temporary connection that is used only to run the specified command and is then closed. If you need a persistent connection, use the Session parameter.
    Type the NETBIOS name, IP address, or fully qualified domain name of one or more computers in a comma-separated list. To specify the local computer, type the computer name, localhost, or a dot (.).
    To use an IP address in the value of ComputerName , the command must include the Credential parameter. Also, the computer must be configured for HTTPS transport or the IP address of the remote computer must be included in the WinRM TrustedHosts list on the local computer. For instructions for adding a computer name to the TrustedHosts list, see "How to Add a Computer to the Trusted Host List" in about_Remote_Troubleshooting.
    On Windows Vista and later versions of the Windows operating system, to include the local computer in the value of ComputerName , you must open Windows PowerShell by using the Run as administrator option.

    .PARAMETER Credential
    Specifies a user account that has permission to perform this action. The default is the current user.
    Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, this cmdlet prompts you for a password.

    .PARAMETER UseSSL
    Indicates that this cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer. By default, SSL is not used.
    WS-Management encrypts all Windows PowerShell content transmitted over the network. The UseSSL parameter is an additional protection that sends the data across an HTTPS, instead of HTTP.
    If you use this parameter, but SSL is not available on the port that is used for the command, the command fails.

    .PARAMETER ThrottleLimit
    Specifies the maximum number of concurrent connections that can be established to run this command. If you omit this parameter or enter a value of 0, the default value, 32, is used.
    The throttle limit applies only to the current command, not to the session or to the computer.

    .PARAMETER Authentication
    Specifies the mechanism that is used to authenticate the user's credentials. The acceptable values for this

    parameter are:

    - Default
    - Basic
    - Credssp
    - Digest
    - Kerberos
    - Negotiate
    - NegotiateWithImplicitCredential

    The default value is Default.

    CredSSP authentication is available only in Windows Vista, Windows Server 2008, and later versions of the Windows operating system.
    For information about the values of this parameter, see the description of the AuthenticationMechanismEnumeration (http://go.microsoft.com/fwlink/?LinkID=144382) in theMicrosoft Developer Network (MSDN) library.
    CAUTION: Credential Security Support Provider (CredSSP) authentication, in which the user's credentials are passed to a remote computer to be authenticated, is designed for commands that require authentication on more than one resource, such as accessing a remote network share. This mechanism increases the security risk of the remote operation. If the remote computer is compromised, the credentials that are passed to it can be used to control the
    network session.

    .EXAMPLE
        Get-LAPSLoggingMode -Computer W10Client1,W10Client2,W10Client3

        Computername LAPSLoggingRegStatus LAPSLogModeDescription       KeyPresent
        ------------ -------------------- ----------------------       ----------
        W10CLIENT1    0                    Silent mode; log errors only True      
        W10CLIENT2                                                      False     
        W10CLIENT3    2                    Verbose mode, log everything True   

        This example retrieves the LAPS CSE Debug Status from several remote computers

    .EXAMPLE
        $cred = Get-Credential
        Get-LAPSLoggingMode -Computer W10Client1,W10Client2,W10Client3 -Credential $cred

        Computername LAPSLoggingRegStatus LAPSLogModeDescription       KeyPresent
        ------------ -------------------- ----------------------       ----------
        W10CLIENT1    0                    Silent mode; log errors only True      
        W10CLIENT2                                                      False     
        W10CLIENT3    2                    Verbose mode, log everything True   

        This example retrieves the LAPS CSE Debug Status from several remote computers using a credential

    .NOTES
        Credits to Jeffery Hicks for the Function Template
        https://jdhitsolutions.com/blog/powershell/6348/building-more-powershell-functions/
    
        Version:          1.0
        Author:           Alex Verboon
        Creation Date:    11.01.2019
        Purpose/Change:   Initial script development

     #>

    [CmdletBinding()]
    [Alias()]
    #[OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName,Position = 0)]
        [string[]]$Computername = $env:COMPUTERNAME,
        [PSCredential]$Credential,
        [switch]$UseSSL,
        [Int32]$ThrottleLimit,
        [ValidateSet('Default', 'Basic', 'Credssp', 'Digest', 'Kerberos', 'Negotiate', 'NegotiateWithImplicitCredential')]
        [ValidateNotNullorEmpty()]
        [string]$Authentication = "default"
    )

    Begin
    {
        $sb = {

            # Location of the LAPS CSE
            $LAPSLoggingRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\GPExtensions\{D76B9641-3288-4f75-942D-087DE603E3EA}"
            # Debug Level Key
            $LAPSLoggingRegKey = "ExtensionDebugLevel"

            [string]$LAPSLogModeDescription = $null
            [string]$LAPSLoggingRegStatus = $null
                
                Write-Verbose "Check if $LAPSLoggingRegKey is present at $LAPSLoggingRegPath on $ENV:Computername"
                $LAPSLoggingRegStatus = Get-ItemProperty -Path $LAPSLoggingRegPath  -Name $LAPSLoggingRegKey -ErrorAction SilentlyContinue | Select-Object $LAPSLoggingRegKey -ExpandProperty $LAPSLoggingRegKey
                    switch ($LAPSLoggingRegStatus)
                    {
                        0 {$LAPSLogModeDescription = "Silent mode; log errors only"}
                        1 {$LAPSLogModeDescription = "Log Errors and warnings"}
                        2 {$LAPSLogModeDescription = "Verbose mode, log everything"}
                    }
                
                    $Object = [ordered]@{
                        Computername = "$env:Computername"
                        LAPSLoggingRegStatus = $LAPSLoggingRegStatus
                        LAPSLogModeDescription = $LAPSLogModeDescription
                        KeyPresent = If ([string]::IsNullOrEmpty($LAPSLoggingRegStatus))  {"$False"} Else {"$True"}
                    }
                    $LAPSResult = (New-Object -TypeName PSObject -Property $object)
                    $LAPSResult
    } #end scriptblock
            
            if ($PSBoundParameters.ContainsKey("Computername")) {
                $sbRemote = {
                # Get Remote Verbose Preference
                    $VerbosePreference = $using:VerbosePreference
                }
                $newScriptBlock = [ScriptBlock]::Create($sbRemote.ToString() + $sb.ToString())
                $sb = $newScriptBlock
            }

            #update PSBoundParameters so it can be splatted to Invoke-Command
            $PSBoundParameters.Add("ScriptBlock", $sb) | Out-Null
            $PSBoundParameters.Add("HideComputername", $True) | Out-Null

    }

    Process
    {
        if (-Not $PSBoundParameters.ContainsKey("Computername")) {
            # There is no computername provided so we run things locally. 
            & $sb
        }
        else {
            #$PSBoundParameters | Out-String | Write-Verbose
            Invoke-Command @PSBoundParameters -ArgumentList $VerbosePreference | Select-Object -Property * -ExcludeProperty RunspaceID, PS*
        }
    }
    End
    {
    }
}