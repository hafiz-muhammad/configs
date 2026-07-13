# List the top 5 processes that consume the most CPU
function Get-TopProcess { Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 }

# List the top 5 processes that consume the most memory
function Get-MemoryHog ([int]$Count = 5) {
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First $Count Name, 
    @{n = "RAM(GB)"; e = { "{0:N2}" -f ($_.WorkingSet64 / 1GB) } },
    @{n = "RAM(MB)"; e = { "{0:N2}" -f ($_.WorkingSet64 / 1MB) } } | 
    Format-Table -AutoSize
}

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

# Terminates all running instances of a specific process by name
function Stop-TargetProcess ($Name) {
    # Exit if no process name is provided
    if (-not $Name) { Write-Warning "Provide a process name to terminate."; return }
    
    # Check if the process is currently running
    $Procs = Get-Process $Name -ErrorAction SilentlyContinue
    
    # Terminate the process if found, otherwise show a warning
    if ($Procs) {
        $Procs | Stop-Process -Force
        Write-Host "Successfully terminated all instances of '$Name'." -ForegroundColor Green
    } else {
        Write-Warning "No active processes found matching '$Name'."
    }
}
