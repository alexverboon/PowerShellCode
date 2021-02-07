function Validate-DkimConfig
{
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$false)]
        [string]$domain,
        [parameter(Mandatory=$false)]
        [switch]$showAll
    )

    $notFound=$false;

    if ($domain) {
        $config = Get-DkimSigningConfig -Identity $domain -ErrorAction SilentlyContinue
        if ($config) {
            Validate-DkimConfigDomain $config -showAll:$showAll
        } else {
            $notFound=$true;
        }
    }
    else {
        $configs = Get-DkimSigningConfig
        if ($configs -and $configs.Count -gt 0) {
            foreach ($config in $configs) { Validate-DkimConfigDomain $config -showAll:$showAll}
        } else { 
            Write-Host
            Write-Host "No DKIM Signing Configs Found" -ForegroundColor Yellow
            Write-Host
        }
    }

    if ($notFound -and $domain) {
        Write-Host
        Write-Host "Config for domain $($domain) Not Found" -ForegroundColor Yellow
        Write-Host

        if (!$domain.EndsWith("onmicrosoft.com") -and !$domain.EndsWith("microsoftonline.com")) {
            Validate-DkimCnameOnly $domain
        }
    }
}

# Performs the main validation of a configuration
function Validate-DkimConfigDomain
{
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$true)]
        $config,
        [parameter(Mandatory=$false)]
        [switch]$showAll
    )

    # Display the configuration
    $domain = $config.Domain;
    $onmicrosoft = if ($domain.EndsWith("onmicrosoft.com") -or $domain.EndsWith("microsoftonline.com")) { $true } else { $false }
    $actions = @()

    Write-Host "Config for $domain Found..." -ForegroundColor Yellow
    if ($showAll) {
        $config | fl
    }
    else {
        $config | Select Identity, Enabled, Status, Selector1CNAME, Selector2CNAME, KeyCreationTime, LastChecked, RotateOnDate, SelectorBeforeRotateonDate, SelectorAfterRotateonDate | fl
    }

    if (!$config.Enabled) {
        Write-Host "Config $($config.Name) Not Enabled" -ForegroundColor Yellow
        Write-Host
        $actions += "Config $($config.Name) needs to be Enabled"
    }

    # Get the DNS ENtries
    Write-Host "Locating DNS Entries..." -ForegroundColor Yellow
    $cname1 = "selector1._domainkey.$($domain)"
    $cname2 = "selector2._domainkey.$($domain)"
    $txt1 = $config.Selector1CNAME;
    $txt2 = $config.Selector2CNAME;

    $cname1Dns = Resolve-DnsName -Name $cname1 -Type CNAME -ErrorAction SilentlyContinue
    $cname2Dns = Resolve-DnsName -Name $cname2 -Type CNAME -ErrorAction SilentlyContinue
    $txt1Dns = Resolve-DnsName -Name $txt1 -Type TXT -ErrorAction SilentlyContinue
    $txt2Dns = Resolve-DnsName -Name $txt2 -Type TXT -ErrorAction SilentlyContinue

    # Validate Entries
    Write-Host "Validating DNS Entries..." -ForegroundColor Yellow    

    Write-Host    
    Write-Host "Config CNAME1 : $($config.Selector1CNAME)"
    if (!$onmicrosoft) {
        if ($cname1Dns -and $cname1Dns.NameHost) {
            Write-Host "DNS    CNAME1 : $($cname1Dns.NameHost)"
            Write-Host "TXT Hostname  : $($cname1)"  
            $match = if ($config.Selector1CNAME.Trim() -eq $cname1Dns.NameHost.Trim()) { $true } else { $false }
            if ($match) { 
                write-host "Matched       : $($match)" -ForegroundColor Green
            } else {
                write-host "Matched       : $($match)" -ForegroundColor Red
                $actions += "Publish CNAME TXT Entry $($cname1) with value $($txt1)"
            }
        }
        else {
            write-host "DNS NotFound  : $($cname1)" -ForegroundColor Red
            $actions += "Publish DNS CNAME Entry $($cname1) with value $($txt1)"
        }              
    }

    Write-Host
    Write-Host "Config CNAME2 : $($config.Selector2CNAME)"
    if (!$onmicrosoft) {
        if ($cname2Dns -and $cname2Dns.NameHost) {
            Write-Host "DNS    CNAME2 : $($cname2Dns.NameHost)"
            Write-Host "TXT Hostname  : $($cname2)"
            $match = if ($config.Selector2CNAME.Trim() -eq $cname2Dns.NameHost.Trim()) { $true } else { $false }
            if ($match) { 
                write-host "Matched       : $($match)" -ForegroundColor Green
            } else {
                write-host "Matched       : $($match)" -ForegroundColor Red
                $actions += "Publish DNS CNAME Entry $($cname2) with value $($txt2)"
            }
        }
        else {
            write-host "DNS NotFound  : $($cname2)" -ForegroundColor Red
            $actions += "Publish DNS CNAME Entry $($cname2) with value $($txt2)"
        }        
    }

    Write-Host
    Write-Host "Config   TXT1 : $($config.Selector1PublicKey)"
    if ($txt1Dns -and $txt1Dns.Strings) {
        $key = $txt1Dns.Strings[0].Trim()
        Write-Host "DNS      TXT1 : $($key)"
        $match = if (Compare-PublicAndConfigKeys $key $config.Selector1PublicKey) { $true } else { $false }
        if ($match) { 
            write-host "Key Match     : $($match)" -ForegroundColor Green
        } else {
            write-host "Key Match     : $($match)" -ForegroundColor Red
            $actions += "Public Key in TXT Entry $($txt1) needs to be republished..."
        }
    }
    else {
        write-host "DNS NotFound  : $($txt1)" -ForegroundColor Red
        $actions += "Microsoft TXT Entry $($txt1) not found so Signing Config needs to be recreated..."
    }

    Write-Host
    Write-Host "Config   TXT2 : $($config.Selector2PublicKey)"
    if ($txt2Dns -and $txt2Dns.Strings) {
        $key = $txt2Dns.Strings[0].Trim()
        Write-Host "DNS      TXT2 : $($key)"
        $match = if (Compare-PublicAndConfigKeys $key $config.Selector2PublicKey) { $true } else { $false }
        if ($match) { 
            write-host "Key Match     : $($match)" -ForegroundColor Green
        } else {
            write-host "Key Match     : $($match)" -ForegroundColor Red
            $actions += "Public Key in TXT Entry $($txt2) needs to be republished..."
        }        
    }
    else {
        write-host "DNS NotFound  : $($txt2)" -ForegroundColor Red
        $actions += "Microsoft TXT Entry $($txt2) not found so Signing Config needs to be recreated..."
    }

    # Write out neccessary Actions
    Write-Host
    if ($actions.Count -gt 0) {
        Write-Host "Required Actions..." -ForegroundColor Yellow
        foreach ($action in $actions) { write-host $action}
    }
}

# Performs a validation of the Dkim CNAMES
function Validate-DkimCnameOnly
{
    [cmdletbinding()]
    Param(
        [parameter(Mandatory=$true)]
        $domain
    )

    # Get the DNS ENtries
    Write-Host "Locating DNS Entries..." -ForegroundColor Yellow
    $cname1 = "selector1._domainkey.$($domain)"
    $cname2 = "selector2._domainkey.$($domain)"

    $cname1Dns = Resolve-DnsName -Name $cname1 -Type CNAME -ErrorAction SilentlyContinue
    $cname2Dns = Resolve-DnsName -Name $cname2 -Type CNAME -ErrorAction SilentlyContinue

    Write-Host    

    if ($cname1Dns) {
        Write-Host "DNS CNAME1 : $($cname1)" -ForegroundColor Green
        Write-Host "Host Value : $($cname1Dns.NameHost)"
    }
    else {
        write-host "CNAME1 NotFound  : $($cname1)" -ForegroundColor Red
    }
    
    if ($cname2Dns) {
        Write-Host "DNS CNAME2 : $($cname2)" -ForegroundColor Green
        Write-Host "Host Value : $($cname2Dns.NameHost)"
    }
    else {
        write-host "CNAME2 NotFound  : $($cname2)" -ForegroundColor Red
    }           

    Write-Host
}

# Compares public and published keys
function Compare-PublicAndConfigKeys([string] $publicKey, [string] $configKey)
{
    $match = $false;

    if (![string]::IsNullOrWhiteSpace($publicKey) -and ![string]::IsNullOrWhiteSpace($configKey)) {     
        $regex = "p=(.*?);"
        $foundPublic = $publicKey -match $regex
        $publicValue = if ($foundPublic) { $matches[1] } else { $null }
        $foundConfig = $configKey -match $regex
        $configValue = if ($foundConfig) { $matches[1] } else { $null } 

        if ($foundPublic -and $foundConfig) {
            if ($publicValue.Trim() -eq $configValue.Trim()) {
                $match = $true;
            }
        }
    }

    $match;
}