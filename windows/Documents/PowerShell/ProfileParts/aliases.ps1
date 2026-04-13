# ----------------------------
# Filesystem
# ----------------------------

# Navigate directory
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

# Make directory and enter it
function New-Directory {
    param([Parameter(Mandatory)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

Set-Alias -Name mkcd -Value New-Directory

# Create one or more new PowerShell script files in the current working directory
function New-PowerShellScriptFile {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$names
    )
    if (-not $names) {
        Write-Host "Usage: nps1 name1 [name2 ...]"
        return
    }
    foreach ($name in $names) {
        $fname = $name
        if ($fname -notlike "*.ps1") { $fname = "$fname.ps1" }
        if (Test-Path $fname) {
            Write-Host "File $fname exists!"
            continue
        }
        New-Item -ItemType File -Path $fname
        Write-Host "Created $fname"
    }
}

Set-Alias -Name newps1 -Value New-PowerShellScriptFile

# ----------------------------
# Process Management
# ----------------------------

# List the top 5 processes that consume the most CPU
function Get-TopProcess { Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 }

Set-Alias -Name cpuhog -Value Get-TopProcess 

# List the top 5 processes that consume the most memory
function Get-MemoryHog ([int]$Count = 5) {
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First $Count Name, 
    @{n = "RAM(GB)"; e = { "{0:N2}" -f ($_.WorkingSet64 / 1GB) } },
    @{n = "RAM(MB)"; e = { "{0:N2}" -f ($_.WorkingSet64 / 1MB) } } | 
    Format-Table -AutoSize
}

Set-Alias -Name ramhog -Value Get-MemoryHog

# Get the start time and uptime of a selected process
function Get-ProcessUptime ($Name) {
    # Check if Name was provided; if not, show usage and exit
    if (-not $Name) {
        Write-Host "Usage: since <ProcessName>"
        return
    }

    # Sort by StartTime to find the root process in multi-process apps
    $proc = Get-Process $Name -ErrorAction SilentlyContinue | Sort-Object StartTime | Select-Object -First 1
    
    if ($proc) {
        $proc | Select-Object Name, 
        @{n = "Started"; e = { $_.StartTime.ToString("MM/dd/yy") } },
        @{n = "Uptime"; e = {
                $age = (Get-Date) - $_.StartTime
                # Format using TotalHours to support processes running greater than 24 hours
                "{0:00}:{1:00}:{2:00}" -f [int]$age.TotalHours, $age.Minutes, $age.Seconds
            }
        } | Format-Table -AutoSize
    }
    else {
        Write-Warning "Process '$Name' not found. Make sure the app is running."
    }
}

Set-Alias -Name since -Value Get-ProcessUptime

# ----------------------------
# PowerShell Profile
# ----------------------------

# Get all PowerShell profile paths
function Get-ProfilePaths {
    $PROFILE | Select-Object *
}

Set-Alias -Name profpath -Value Get-ProfilePaths

# Reload profile without restarting PowerShell
function Invoke-ProfileReload { . $PROFILE }

Set-Alias -Name reload -Value Invoke-ProfileReload

# Manually install and set profile dependencies
# Alias for Initialize-Setup in ProfileParts/setup.ps1
Set-Alias -Name profsetup -Value Initialize-Setup

# Show command history
function Get-CommandHistory { Get-Content (Get-PSReadLineOption).HistorySavePath }

Set-Alias -Name allhist -Value Get-CommandHistory

# ----------------------------
# Networking
# ----------------------------

# Flush DNS cache
function Clear-DnsCache { Clear-DnsClientCache; Write-Host "DNS cache flushed." }

Set-Alias -Name flushdns -Value Clear-DnsCache

# Auto update Windows hosts file from hafiz-muhammad/configs GitHub repository
function Update-HostsFile {
    # Check if PowerShell running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "This function must be run as Administrator!"
        Write-Host "Please restart PowerShell as Administrator, then run 'updatehosts' again."
        return
    }

    $githubUrl = "https://raw.githubusercontent.com/hafiz-muhammad/configs/refs/heads/main/windows/System32/drivers/etc/hosts"
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

    # Download hosts file to a temp location
    $tempHosts = "$env:TEMP\hosts_from_github"
    Invoke-WebRequest -Uri $githubUrl -OutFile $tempHosts

    # Backup existing hosts file
    $backupPath = "$hostsPath.bak"
    Copy-Item $hostsPath $backupPath -Force

    # Replace hosts file
    Copy-Item $tempHosts $hostsPath -Force

    Remove-Item $tempHosts -Force

    Write-Host "Hosts file updated. Backup at $backupPath"
}

Set-Alias -Name updatehosts -Value Update-HostsFile

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

Set-Alias -Name listenports -Value Get-ListeningPorts

# ----------------------------
# User Management
# ----------------------------

# List all user accounts
function Get-LocalUsers {
    Get-LocalUser | Select-Object Name, Enabled, LastLogon | Format-Table -AutoSize
}

Set-Alias -Name lusers -Value Get-LocalUsers

# Enable & disable built-in Administrator account
function Set-AdministratorAccountStatus {
    param(
        [ValidateSet("enable", "disable", "on", "off")]
        [string]$status
    )

    # Show usage if no status provided
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Usage Examples:" -ForegroundColor Gray
        Write-Host "  setadmin enable (or 'on')"
        Write-Host "  setadmin disable (or 'off')"
        return
    }

    # Check if running with admin rights
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Administrator rights required. Relaunching..." -ForegroundColor Yellow
        
        # Re-run this function with admin privileges
        $fullScript = @"
function Set-AdministratorAccountStatus { $($MyInvocation.MyCommand.ScriptBlock) }
Set-AdministratorAccountStatus -status '$status'
"@

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($fullScript)
        # Encode command to pass safely via command line
        $encodedCommand = [Convert]::ToBase64String($bytes)

        try {
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile", "-NoExit", "-EncodedCommand", $encodedCommand
        }
        catch {
            Write-Host "User Account Control (UAC) prompt declined." -ForegroundColor Red
        }
        return
    }

    Write-Host "Run as admin - SUCCESSFUL" -ForegroundColor Green
    Start-Sleep -Seconds 1

    # Get current Administrator account state
    $user = Get-LocalUser -Name "Administrator"

    # Enable Administrator if requested
    if ($status -eq "enable" -or $status -eq "on") {
        if ($user.Enabled -eq $false) {
            Enable-LocalUser -Name "Administrator"
            Write-Host "Administrator account enabled." -ForegroundColor Green
        }
        else {
            Write-Host "Administrator account is already enabled." -ForegroundColor Cyan
        }
    }
    # Disable Administrator if requested
    elseif ($status -eq "disable" -or $status -eq "off") {
        if ($user.Enabled -eq $true) {
            Disable-LocalUser -Name "Administrator"
            Write-Host "Administrator account disabled." -ForegroundColor Green
        }
        else {
            Write-Host "Administrator account is already disabled." -ForegroundColor Cyan
        }
    }
}

Set-Alias -Name setadmin -Value Set-AdministratorAccountStatus

# ----------------------------
# Miscellaneous
# ----------------------------

# Enable & disable God Mode
# Create Windows 'God Mode' folder on your desktop
function Set-GodMode {
    param(
        [ValidateSet("enable", "disable", "on", "off")]
        [string]$status
    )

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Usage Examples:" -ForegroundColor Gray
        Write-Host "  godmode enable (or 'on')"
        Write-Host "  godmode disable (or 'off')"
        return
    }

    $desktop = [Environment]::GetFolderPath('Desktop')
    $folderPath = Join-Path $desktop 'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}'

    # Enable God Mode
    if ($status -eq "enable" -or $status -eq "on") {
        if (-not (Test-Path $folderPath)) {
            New-Item -Path $folderPath -ItemType Directory | Out-Null
            Write-Host "God Mode folder created on your desktop." -ForegroundColor Green
        }
        else {
            Write-Host "God Mode folder already exists." -ForegroundColor Cyan
        }
    }
    
    # Disable God Mode
    elseif ($status -eq "disable" -or $status -eq "off") {
        if (Test-Path $folderPath) {
            Remove-Item -Path $folderPath -Recurse -Force
            Write-Host "God Mode folder removed from your desktop." -ForegroundColor Green
        }
        else {
            Write-Host "God Mode folder does not exist." -ForegroundColor Cyan
        }
    }
}

Set-Alias -Name godmode -Value Set-GodMode

# Upgrade Oh My Posh
function Update-OhMyPosh { oh-my-posh upgrade }

Set-Alias -Name ompupgrade -Value Update-OhMyPosh

# Launch Chris Titus Tech Windows Utility (Stable Branch)
function Invoke-ChrisTitusWinUtility { irm "https://christitus.com/win" | iex }

Set-Alias -Name cttwin -Value Invoke-ChrisTitusWinUtility

# Clear Windows clipboard
function Clear-Clipboard { Set-Clipboard ' '; Write-Host "Clipboard cleared." }

Set-Alias -Name clearcb -Value Clear-Clipboard
