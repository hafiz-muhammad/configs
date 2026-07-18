# List all user accounts
function Get-LocalUsers {
    Get-LocalUser | Select-Object Name, Enabled, LastLogon | Format-Table -AutoSize
}

# Enable & disable built-in Administrator account
function Set-AdministratorAccountStatus {
    param(
        [ValidateSet("enable", "disable", "on", "off")]
        [string]$status
    )

    # Show usage if no status provided
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Usage Examples:" -ForegroundColor Gray
        Write-Host "  setadmin enable (or 'on')"
        Write-Host "  setadmin disable (or 'off')"
        return
    }

    # Check if running with admin rights
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Administrator rights required. Relaunching..." -ForegroundColor Yellow
        
        # Re-run this function with admin privileges
        $fullScript = @"
function Set-AdministratorAccountStatus { $($MyInvocation.MyCommand.ScriptBlock) }
Set-AdministratorAccountStatus -status '$status'
"@

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($fullScript)
        # Encode command to pass safely via command line
        $encodedCommand = [Convert]::ToBase64String($bytes)

        try {
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile", "-NoExit", "-EncodedCommand", $encodedCommand
        }
        catch {
            Write-Host "User Account Control (UAC) prompt declined." -ForegroundColor Red
        }
        return
    }

    Write-Host "Run as admin - SUCCESSFUL" -ForegroundColor Green
    Start-Sleep -Seconds 1

    # Get current Administrator account state
    $user = Get-LocalUser -Name "Administrator"

    # Enable Administrator if requested
    if ($status -eq "enable" -or $status -eq "on") {
        if ($user.Enabled -eq $false) {
            Enable-LocalUser -Name "Administrator"
            Write-Host "Administrator account enabled." -ForegroundColor Green
        }
        else {
            Write-Host "Administrator account is already enabled." -ForegroundColor Cyan
        }
    }
    # Disable Administrator if requested
    elseif ($status -eq "disable" -or $status -eq "off") {
        if ($user.Enabled -eq $true) {
            Disable-LocalUser -Name "Administrator"
            Write-Host "Administrator account disabled." -ForegroundColor Green
        }
        else {
            Write-Host "Administrator account is already disabled." -ForegroundColor Cyan
        }
    }
}
