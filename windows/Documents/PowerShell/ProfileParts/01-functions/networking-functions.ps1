# Flush DNS cache
function Clear-DnsCache { Clear-DnsClientCache; Write-Host "DNS cache flushed." }

# Auto update Windows hosts file from hafiz-muhammad/configs GitHub repository
function Update-HostsFile {
    $githubUrl = "https://raw.githubusercontent.com/hafiz-muhammad/configs/refs/heads/main/windows/System32/drivers/etc/hosts"
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

    # Check for Admin rights; relaunch elevated if necessary
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Administrator rights required." -ForegroundColor Yellow

        # Script block to execute in the new elevated session
        $fullScript = @"
`$ProgressPreference = 'SilentlyContinue'
`$githubUrl = '$githubUrl'
`$hostsPath = '$hostsPath'
`$tempHosts = "`$env:TEMP\hosts_from_github"

Invoke-WebRequest -Uri `$githubUrl -OutFile `$tempHosts

`$backupPath = "`$hostsPath.bak"
Copy-Item `$hostsPath `$backupPath -Force
Copy-Item `$tempHosts `$hostsPath -Force
Remove-Item `$tempHosts -Force

Write-Host "Hosts file updated. Backup at `$backupPath" -ForegroundColor Green
"@

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($fullScript)
        $encodedCommand = [Convert]::ToBase64String($bytes)

        try {
            Start-Process wt.exe -Verb RunAs -ArgumentList @(
                "new-tab",
                "pwsh",
                "-NoExit",
                "-EncodedCommand", $encodedCommand
            )
        }
        catch {
            Write-Host "User Account Control (UAC) prompt declined." -ForegroundColor Red
        }
        return
    }

    # Direct execution if already Administrator
    $tempHosts = "$env:TEMP\hosts_from_github"
    Invoke-WebRequest -Uri $githubUrl -OutFile $tempHosts

    $backupPath = "$hostsPath.bak"
    Copy-Item $hostsPath $backupPath -Force
    Copy-Item $tempHosts $hostsPath -Force
    Remove-Item $tempHosts -Force

    Write-Host "Hosts file updated. Backup at $backupPath"
}

# Get hosts file update status
function Get-HostsFileStatus {
    $GitHubUser = "hafiz-muhammad"
    $RepoName = "configs"
    $RepoHostsPath = "windows/System32/drivers/etc/hosts" 
    $LocalHostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    Write-Host "Checking for hosts file updates..." -ForegroundColor Cyan

    # Get local file info
    if (Test-Path $LocalHostsPath) {
        $LocalLastWrite = (Get-Item $LocalHostsPath).LastWriteTime
        $LocalLastWriteFormatted = $LocalLastWrite.ToString("MM/dd/yyyy hh:mm:ss tt")
        Write-Host "Last local hosts file update:  $LocalLastWriteFormatted" -ForegroundColor Yellow
    } else {
        $LocalLastWrite = [DateTime]::MinValue
        Write-Host "Local hosts file not found!" -ForegroundColor Red
    }

    # Get remote file info via GitHub API
    $ApiUrl = "https://api.github.com/repos/$GitHubUser/$RepoName/commits?path=$RepoHostsPath&page=1&per_page=1"

    try {
        # Headers for GitHub API compliance and clean JSON formatting
        $Headers = @{"Accept" = "application/vnd.github.v3+json"; "User-Agent" = "PowerShell-Update-Checker"}
        $CommitInfo = Invoke-RestMethod -Uri $ApiUrl -Headers $Headers -Method Get
        
        if ($null -ne $CommitInfo -and $CommitInfo.Count -gt 0) {
            $RemoteCommitDate = [DateTime]::Parse($CommitInfo[0].commit.committer.date).ToLocalTime()
            $RemoteCommitDateFormatted = $RemoteCommitDate.ToString("MM/dd/yyyy hh:mm:ss tt")
            
            Write-Host "Last remote hosts file update: $RemoteCommitDateFormatted" -ForegroundColor Cyan
            
            # Compare dates
            if ($RemoteCommitDate -gt $LocalLastWrite) {
                Write-Host "Hosts file update is available!" -ForegroundColor Magenta
            } else {
                Write-Host "Your hosts file is up to date." -ForegroundColor Green
            }
        } else {
            Write-Host "No commit history found for this file on GitHub." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Could not connect to GitHub to check for updates: $_" -ForegroundColor Red
    }
}

# Get local listening ports with process name and details
function Get-ListeningPorts {
    netstat -ano | Select-String "LISTENING" | ForEach-Object {
        $line = $_.ToString() -replace '\s+', ' '
        $tokens = $line.Trim().Split(' ')
        if ($tokens.Count -ge 5) {
            $protocol = $tokens[1]
            $localAddress = $tokens[2]
            $listenPid = $tokens[4]

            # Get process name safely
            try {
                $process = Get-Process -Id $listenPid -ErrorAction Stop
                $procName = $process.ProcessName
            }
            catch {
                $procName = "<N/A>"
            }

            [PSCustomObject]@{
                Protocol     = $protocol
                LocalAddress = $localAddress
                ProcessId    = $listenPid
                Process      = $procName
            }
        }
    } | Sort-Object LocalAddress | Format-Table -AutoSize
}

# Set predefined DNS servers
function Set-DNS {
    param (
        [string]$Provider
    )

    # Relaunch elevated if not running as Administrator
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Administrator rights required." -ForegroundColor Yellow

        $fullScript = @"
`$ProgressPreference = 'SilentlyContinue'
Set-DNS '$Provider'
"@

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($fullScript)
        $encodedCommand = [Convert]::ToBase64String($bytes)

        try {
            Start-Process wt.exe -Verb RunAs -ArgumentList @(
                "new-tab",
                "pwsh",
                "-NoExit",
                "-EncodedCommand", $encodedCommand
            )
        }
        catch {
            Write-Host "User Account Control (UAC) prompt declined." -ForegroundColor Red
        }
        return
    }

    # DNS server definitions
    $DNSData = @{
        # Quad9 recommended for malware blocking, DNSSEC Validation; anonymized logging
        'quad9' = @('9.9.9.9', '149.112.112.112', '2620:fe::fe', '2620:fe::9')

        # Cloudflare DNS servers with focus on speed and privacy; anonymized logging
        'cloudflare' = @('1.1.1.1', '1.0.0.1', '2606:4700:4700::1111', '2606:4700:4700::1001')

        # AdGuard default servers with ad and tracker blocking; anonymized logging
        'adguard' = @('94.140.14.14', '94.140.15.15', '2a10:50c0::ad1:ff', '2a10:50c0::ad2:ff')

        # Mullvad encrypted DNS; no logging
        'mullvad' = @('194.242.2.2', '2a07:e340::2')

        # Reset to network defaults
        'dhcp' = $null  
    }

    # Mullvad DoH (DNS over HTTPS) isolation block
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectUsageOfAssignment", "")]
    $EnableMullvadSecureDoh = {
        param($Adapter, $CurrentProvider)
        if ($CurrentProvider -ne 'mullvad') { return }

        $v4Server = '194.242.2.2'
        $v6Server = '2a07:e340::2'
        $Template = 'https://dns.mullvad.net/dns-query'

        # Register global system DoH templates
        if (-not (Get-DnsClientDohServerAddress -ServerAddress $v4Server -ErrorAction SilentlyContinue)) {
            Add-DnsClientDohServerAddress -ServerAddress $v4Server -DohTemplate $Template -AllowFallbackToUdp $False -AutoUpgrade $True
        }
        if (-not (Get-DnsClientDohServerAddress -ServerAddress $v6Server -ErrorAction SilentlyContinue)) {
            Add-DnsClientDohServerAddress -ServerAddress $v6Server -DohTemplate $Template -AllowFallbackToUdp $False -AutoUpgrade $True
        }

        # Enforce adapter level encrypted only DoH via registry
        if ($Adapter) {
            $BasePath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$($Adapter.InterfaceGuid)\DohInterfaceSettings"
            
            # Configure IPv4 encrypted only mode
            $v4Path = "$BasePath\Doh\$v4Server"
            if (-not (Test-Path $v4Path)) { New-Item -Path $v4Path -Force | Out-Null }
            New-ItemProperty -Path $v4Path -Name "DohFlags" -Value 1 -PropertyType QWORD -Force | Out-Null

            # Configure IPv6 encrypted only mode (using semicolon path format)
            $v6Encoded = $v6Server -replace ':', ';'
            $v6Path = "$BasePath\Doh6\$v6Encoded"
            if (-not (Test-Path $v6Path)) { New-Item -Path $v6Path -Force | Out-Null }
            New-ItemProperty -Path $v6Path -Name "DohFlags" -Value 1 -PropertyType QWORD -Force | Out-Null
        }
    }

    $ValidProviders = $DNSData.Keys | Sort-Object

    # Interactive loop
    do {
        if ([string]::IsNullOrWhiteSpace($Provider)) {
            # Display current live DNS configurations
            Write-Host "`nCurrent DNS Settings:" -ForegroundColor Cyan
            $ActiveAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
            foreach ($Interface in $ActiveAdapters) {
                $DnsAddresses = (Get-DnsClientServerAddress -InterfaceIndex $Interface.InterfaceIndex).ServerAddresses
                if ($DnsAddresses) {
                    $AddressesString = $DnsAddresses -join ', '
                    Write-Host "  $($Interface.Name): " -NoNewline -ForegroundColor DarkGray
                    Write-Host $AddressesString -ForegroundColor Gray
                }
            }

            Write-Host "`nAvailable DNS Providers:" -ForegroundColor Yellow
            Write-Host "  0) exit"

            for ($i = 0; $i -lt $ValidProviders.Count; $i++) {
                Write-Host "  $($i + 1)) $($ValidProviders[$i])"
            }
            Write-Host ""
            
            $Selection = Read-Host "Select a provider (type name or number)"

            if ($Selection -eq '0' -or $Selection -eq 'exit') {
                $CurrentProvider = 'exit'
            }
            elseif ($Selection -match '^\d+$' -and $Selection -le $ValidProviders.Count -and $Selection -gt 0) {
                $CurrentProvider = $ValidProviders[$Selection - 1]
            } else {
                $CurrentProvider = $Selection
            }
        } else {
            $CurrentProvider = $Provider
            $Provider = $null
        }

        if ($CurrentProvider -eq 'exit') {
            Write-Host "Exiting..." -ForegroundColor Yellow
            break
        }

        # Input validation
        if ([string]::IsNullOrWhiteSpace($CurrentProvider) -or $CurrentProvider -notin $ValidProviders) {
            Write-Host "`n[ERROR] '$CurrentProvider' is not a valid option." -ForegroundColor Red
            Write-Host "Please choose a number from the menu or type: $($ValidProviders -join ', ')" -ForegroundColor DarkGray
            
            Start-Sleep -Seconds 2
            continue
        }

        # Apply settings to active network interfaces
        $DnsServers = $DNSData[$CurrentProvider.ToLower()]
        $ActiveInterfaces = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

        foreach ($Adapter in $ActiveInterfaces) {
            if ($CurrentProvider -eq 'dhcp') {
                Write-Host "Resetting DNS to DHCP for adapter: $($Adapter.Name)..." -ForegroundColor Cyan
                Set-DnsClientServerAddress -InterfaceIndex $Adapter.InterfaceIndex -ResetServerAddresses
            } else {
                Write-Host "Setting DNS to $CurrentProvider for adapter: $($Adapter.Name)..." -ForegroundColor Green
                Set-DnsClientServerAddress -InterfaceIndex $Adapter.InterfaceIndex -ServerAddresses $DnsServers

                # Apply Mullvad specific DoH settings
                & $EnableMullvadSecureDoh -Adapter $Adapter -CurrentProvider $CurrentProvider
            }
        }
        
        Clear-DnsClientCache
        
    } while ($true)
}

# Parameter tab-completion
Register-ArgumentCompleter -CommandName 'Set-DNS' -ParameterName 'Provider' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $Targets = @('quad9', 'cloudflare', 'adguard', 'dhcp', 'mullvad', 'exit') 
    $Targets | Where-Object { $_ -like "$wordToComplete*" }
}
