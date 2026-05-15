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
