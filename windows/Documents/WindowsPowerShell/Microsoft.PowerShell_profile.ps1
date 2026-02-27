# ----------------------------
# Filesystem
# ----------------------------

# Navigate directory
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

# Make directory and enter it
function mkcd {
    param([Parameter(Mandatory)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

# Create one or more PowerShell script files in the current working directory
function new-ps1 {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$names
    )
    if (-not $names) {
        Write-Host "Usage: new-ps1 name1 [name2 ...]"
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

# Create a Windows 'God Mode' folder on your desktop
function godmode {
    $folder = Join-Path ([Environment]::GetFolderPath('Desktop')) 'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}'
    if (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory | Out-Null
        Write-Host "God Mode folder created on your desktop."
    } else {
        Write-Host "God Mode folder already exists on your desktop."
    }
}

# Remove 'God Mode' folder from your desktop
function ungodmode {
    $folder = Join-Path ([Environment]::GetFolderPath('Desktop')) 'GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}'
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Host "God Mode folder removed from your desktop."
    } else {
        Write-Host "God Mode folder does not exist on your desktop."
    }
}

# ----------------------------
# Profile Utilities
# ----------------------------

# Get all PowerShell profile paths
function pprof {
	$PROFILE | Select-Object *
}

# Reload profile without restarting PowerShell
function reload { . $PROFILE }

# ----------------------------
# Networking
# ----------------------------

# Flush DNS cache
function flushdns { Clear-DnsClientCache; Write-Host "DNS cache flushed." }

# Auto update Windows hosts file from hafiz-muhammad/configs GitHub repository
function update-hosts {
    # Check if PowerShell running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "This function must be run as Administrator!"
        Write-Host "Please restart PowerShell as Administrator, then run 'update-hosts' again."
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

# Get local listening ports with process name and details
function get-listeningports {
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
            } catch {
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

# ----------------------------
# Miscellaneous
# ----------------------------

# Set Oh My Posh theme
oh-my-posh init pwsh --config "$Env:LOCALAPPDATA\Programs\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression

# Launch Chris Titus Tech Windows Utility (Stable Branch)
function cttwin { irm "https://christitus.com/win" | iex }

# Clear Windows clipboard
function clearcb { Set-Clipboard ' '; Write-Host "Clipboard cleared."}
