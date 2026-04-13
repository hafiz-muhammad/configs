Import-Module PSReadLine -ErrorAction SilentlyContinue

# Dot source setup.ps1 then recursively load other ps1 files
$ScriptPath = "$HOME\Documents\PowerShell\ProfileParts"

if (Test-Path $ScriptPath) {
    . (Join-Path $ScriptPath "setup.ps1")

    $Files = Get-ChildItem -Path $ScriptPath -Filter *.ps1 -File -Recurse -Depth 1 | 
         Where-Object { $_.Name -ne "setup.ps1" }

    foreach ($File in $Files) {
        . $File.FullName
    }
}

# Configure PSReadLine history size
Set-PSReadLineOption -MaximumHistoryCount 10000

# Set Oh My Posh theme
oh-my-posh --init --shell pwsh --config "$Env:LOCALAPPDATA\Programs\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
