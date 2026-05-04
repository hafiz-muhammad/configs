:; # Linux/Bash section
:; # Define paths
:; HELIX_DIR="$HOME/.config/helix"
:; if [ ! -d "$HELIX_DIR" ]; then HELIX_DIR="$HOME/AppData/Roaming/helix"; fi
:; THEMES_DIR="$HELIX_DIR/themes"
:; CONFIG_FILE="$HELIX_DIR/config.toml"
:; while true; do
:;   clear
:;   echo "--- Helix Theme Selector ---"
:;   # List and count themes
:;   themes=$(ls "$THEMES_DIR" 2>/dev/null | grep '\.toml$' | sed 's/\.toml$//')
:;   count=$(echo "$themes" | grep -c .)
:;   PS3="Select an option (1-$(($count + 1))): "
:;   # Display selection menu
:;   select theme_file in $themes "Exit"; do
:;     if [ "$theme_file" = "Exit" ]; then exit; fi
:;     if [ -n "$theme_file" ]; then
:;       temp_file=$(mktemp)
:;       echo "# Set theme" > "$temp_file"
:;       echo "theme = \"$theme_file\"" >> "$temp_file"
:;       echo "" >> "$temp_file"
:;       # Remove old theme lines and all leading empty lines
:;       grep -vE "^[[:space:]]*#*[[:space:]]*theme|^[[:space:]]*# Set theme" "$CONFIG_FILE" 2>/dev/null | sed -e '/./,$!d' >> "$temp_file"
:;       mv "$temp_file" "$CONFIG_FILE"
:;       echo -e "\033[0;32mTheme set to $theme_file\033[0m"
:;       sleep 2; break
:;     else
:;       echo -e "\033[0;31mInvalid selection.\033[0m"
:;       sleep 2; break
:;     fi
:;   done
:; done
:; exit

@echo off
:: Windows section
setlocal enabledelayedexpansion
:menu
cls
echo --- Helix Theme Selector ---
:: Define paths
set "HELIX_DIR=%AppData%\helix"
set "THEMES_DIR=%HELIX_DIR%\themes"
set "CONFIG_FILE=%HELIX_DIR%\config.toml"

:: Build theme list
set count=0
for %%f in ("%THEMES_DIR%\*.toml") do (
    set /a count+=1
    set "theme[!count!]=%%~nf"
    echo !count!^) %%~nf
)
set /a exit_opt=%count% + 1
echo %exit_opt%^) Exit

echo.
set /p choice="Select an option (1-%exit_opt%): "
if "%choice%"=="%exit_opt%" exit /b
set "selected_theme=!theme[%choice%]!"

if defined selected_theme (
    :: Remove old theme lines and all leading empty lines
    powershell -Command ^
        "$path = '%CONFIG_FILE%';" ^
        "$header = '# Set theme';" ^
        "$newTheme = 'theme = \"%selected_theme%\"';" ^
        "if (Test-Path $path) {" ^
            "$oldContent = Get-Content $path | Where-Object { $_ -notmatch '^\s*#*\s*theme' -and $_ -notmatch '^\s*# Set theme' };" ^
            "while ($oldContent.Count -gt 0 -and [string]::IsNullOrWhiteSpace($oldContent[0])) { $oldContent = $oldContent[1..($oldContent.Count-1)] }" ^
            "$header, $newTheme, '', $oldContent | Set-Content $path" ^
        "} else {" ^
            "$header, $newTheme, '' | Set-Content $path" ^
        "}"
    echo Theme set to %selected_theme%
    timeout /t 2 >nul
    goto menu
) else (
    echo Invalid selection.
    timeout /t 2 >nul
    goto menu
)

