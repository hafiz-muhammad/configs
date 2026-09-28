# Get all PowerShell profile paths
function Get-ProfilePaths {
    $PROFILE | Select-Object *
}

# Reload profile without restarting PowerShell
function Invoke-ProfileReload { . $PROFILE }

# Show command history
function Get-CommandHistory { Get-Content (Get-PSReadLineOption).HistorySavePath }

# Clear active session history and delete the saved history file
function Clear-PSReadLineHistory {
    Clear-History
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    Remove-Item (Get-PSReadLineOption).HistorySavePath -ErrorAction SilentlyContinue
}
