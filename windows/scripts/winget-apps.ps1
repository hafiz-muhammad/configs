# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator to allow software installations."
    exit
}

# Define package IDs
$apps = @(
    # Brave browser
    "Brave.Brave",

    # Mozilla Firefox
    "Mozilla.Firefox",

    # Mozilla Thunderbird
    "Mozilla.Thunderbird",

    # DuckDuckGo Browser
    "DuckDuckGo.DesktopBrowser",

    # UniGetUI
    "Devolutions.UniGetUI",

    # KeePassXC
    "KeePassXCTeam.KeePassXC",

    # Ente Auth
    "ente-io.auth-desktop",
    
    # LocalSend
    "LocalSend.LocalSend",

    # Syncthing
    "BillStewart.SyncthingWindowsSetup",

    # Windows Terminal
    "Microsoft.WindowsTerminal",

    # Helix editor
    "Helix.Helix"
)

Write-Host "Starting software installation via WinGet..." -ForegroundColor Cyan

# Loop through each app and install
foreach ($app in $apps) {
    Write-Host "`n----------------------------------------" -ForegroundColor Yellow
    Write-Host "Installing: $app" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Yellow

    winget install --id $app --source winget --exact --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully installed $app" -ForegroundColor Green
    } else {
        Write-Host "Failed or skipped installing $app (Exit Code: $LASTEXITCODE)" -ForegroundColor Red
    }
}

Write-Host "`nAll tasks completed!" -ForegroundColor Cyan
