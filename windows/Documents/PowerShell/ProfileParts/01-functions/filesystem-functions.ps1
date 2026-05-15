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
