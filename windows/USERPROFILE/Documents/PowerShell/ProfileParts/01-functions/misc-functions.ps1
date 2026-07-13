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

# Upgrade Oh My Posh
function Update-OhMyPosh { oh-my-posh upgrade }

# Launch Chris Titus Tech Windows Utility (Stable Branch)
function Invoke-ChrisTitusWinUtility { irm "https://christitus.com/win" | iex }

# Clear Windows clipboard
function Clear-Clipboard { Set-Clipboard ' '; Write-Host "Clipboard cleared." }
