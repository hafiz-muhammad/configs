# Trust PSGallery
function Set-PSGalleryTrust {
    $repo = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
    if (-not $repo -or $repo.InstallationPolicy -ne "Trusted") {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
        return "PSGallery (Trusted)"
    }
}

# Install PSReadLine if missing
function Install-PSReadLine {
    if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
        Install-Module -Name PSReadLine -Force -AllowClobber -Scope CurrentUser
        return "PSReadLine"
    }
}

# Install FiraCode Nerd Font if missing
function Install-NerdFonts {
    $userFontReg = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    $isInstalled = Get-ItemProperty -Path $userFontReg -ErrorAction SilentlyContinue |
        Get-Member -MemberType NoteProperty | Where-Object Definition -like "*FiraCode*"

    if (-not $isInstalled) {
        if (-not (Get-Module -ListAvailable -Name NerdFonts)) {
            Install-PSResource -Name NerdFonts -TrustRepository
        }

        Import-Module -Name NerdFonts -ErrorAction SilentlyContinue
        Install-NerdFont -Name 'FiraCode' -Scope CurrentUser -ErrorAction SilentlyContinue
        Write-Host "FiraCode Nerd Font installed. Open a new terminal session to apply font rendering." -ForegroundColor Yellow
        return "FiraCode Nerd Font"
    }
}

# Install Terminal-Icons if missing
function Install-TerminalIcons {
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
        Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser
        return "Terminal-Icons"
    }
}

# Check and install missing profile prerequisites
function Initialize-Setup {
    Write-Host "Checking PowerShell profile prerequisites..." -ForegroundColor Cyan
    
    $results = @(
        Set-ExecutionPolicyState
        Set-PSGalleryTrust
        Install-PSReadLine
        Install-NerdFonts
        Install-TerminalIcons
    ) | Where-Object { $_ -ne $null }

    if ($results.Count -gt 0) {
        Write-Host "Updates applied: $($results -join ', ')" -ForegroundColor Green
        . $PROFILE
    } else {
        Write-Host "Everything is already up to date." -ForegroundColor Green
    }
}
