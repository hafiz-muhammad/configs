## Commands

Name                              | Command
----------------------------------|------------------------------------------------------------------------------
Beep this PC                      | `speaker-test -t sine -f 2000 -l 1` 
Lock Screen                       | `loginctl lock-screen`
Log Out                           | `gnome-session-quit --logout --no-prompt`
Mute Microphone                   | `wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1`
Open Terminal (Ptyxis)            | `ptyxis --new-window`
Power Off                         | `systemctl poweroff`
Restart                           | `systemctl reboot`
Set Dark Mode                     | `gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'`
Set Light Mode                    | `gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'`
Suspend                           | `systemctl suspend`
Unlock Screen                     | `loginctl unlock-screen`
Unmute Microphone                 | `wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0`
