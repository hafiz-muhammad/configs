Import-Module PSReadLine -ErrorAction SilentlyContinue

# Dot-source setup.ps1 first, then load other .ps1 files from ProfileParts (excluding setup.ps1)
$ScriptPath = "$HOME\Documents\PowerShell\ProfileParts"

if (Test-Path $ScriptPath) {
    . (Join-Path $ScriptPath "00-setup\setup.ps1")

    $Files = Get-ChildItem -Path $ScriptPath -Filter *.ps1 -File -Recurse -Depth 1 | 
         Where-Object { $_.Name -ne "setup.ps1" }

    foreach ($File in $Files) {
        . $File.FullName
    }
}

# Clear the host and set color variables
Clear-Host
$blue  = "$([char]0x1b)[94m"
$white_bold = "$([char]0x1b)[1;97m"
$cyan  = "$([char]0x1b)[96m"
$reset = "$([char]0x1b)[0m"

# Get user and computer name
$username = [Environment]::UserName
$computername = [Environment]::MachineName

# Determine Account Type
$accountObj = Get-LocalUser | Where-Object { $_.Name -eq $username }
$accountType = if ($accountObj) { 
    $accountObj.PrincipalSource 
} elseif ($env:USERDNSDOMAIN) { 
    "Domain" 
} else { 
    "Cloud / Online" 
}

# Get the current PowerShell version
$psVersion = $PSVersionTable.PSVersion.ToString()

# Get operating system details (Name, Version, Build)
$osName = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption -replace "Microsoft ",""
$osRegistry = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$osVer = $osRegistry.DisplayVersion
$osFullBuild = "$($osRegistry.CurrentBuild).$($osRegistry.UBR)"

# Display the Windows logo along with user, account, shell, and OS details
# Unicode Character '█' Full Block (U+2588) used for the Windows logo
Write-Host ""
Write-Host "  ${blue}██████  ██████" -NoNewline; Write-Host "  ${white_bold}User:${cyan} ${username}@${computername}${reset}"
Write-Host "  ${blue}██████  ██████" -NoNewline; Write-Host "  ${white_bold}Account:${cyan} ${accountType}${reset}"
Write-Host "  ${blue}██████  ██████" -NoNewline; Write-Host "  ${white_bold}Shell:${cyan} PowerShell ${psVersion}${reset}"
Write-Host ""
Write-Host "  ${blue}██████  ██████" -NoNewline; Write-Host "  ${white_bold}OS:${cyan} $osName${reset}"
Write-Host "  ${blue}██████  ██████" -NoNewline; Write-Host "  ${white_bold}Version:${cyan} $osVer${reset}"
Write-Host "  ${blue}██████  ██████${reset}" -NoNewline; Write-Host "  ${white_bold}Build:${cyan} $osFullBuild${reset}"
Write-Host ""

# Tab menu completion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Configure PSReadLine history size
Set-PSReadLineOption -MaximumHistoryCount 10000

# Set Oh My Posh theme
oh-my-posh --init --shell pwsh --config "$Env:LOCALAPPDATA\Programs\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
