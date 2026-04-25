## BitLocker Asks for Recovery Key on a Dual-Boot System
*This is only if your Windows edition supports BitLocker.*
> [!NOTE]
> BitLocker will likely ask for a recovery key when GRUB updates or when it detects a change with boot configuration.

**Options to work around this:** \
**1.** Turn off BitLocker before installing another operating system, and turn it back on after the new OS is installed. **(Only if Windows was already on your system first)** \
**2.** Disable and re-enable BitLocker. \
**3.** Turn off BitLocker.

## Allow PowerShell Script Execution for Current User
**Enter the following in PowerShell:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## Fix PSReadLine Errors in PowerShell

If you're using a custom prompt (like Oh My Posh) and see errors like the ones below, then follow steps 1 to 3 to resolve the issue.

**Common Errors:**
- `Get-PSReadLineKeyHandler : A positional parameter cannot be found that accepts argument 'Spacebar'.`
- `Get-PSReadLineKeyHandler : A positional parameter cannot be found that accepts argument 'Enter'.`
- `Get-PSReadLineKeyHandler : A positional parameter cannot be found that accepts argument 'Ctrl+c'.`

**How to Fix:**

**1.** Trust the PowerShell Gallery
```powershell
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
```
**2.** Install the latest PSReadLine module
```powershell
Install-Module PSReadLine -Force -AllowClobber -Scope CurrentUser
```
**3.** Restart your Terminal



