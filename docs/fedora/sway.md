## Sway Spin Essential & Customization List

<details><summary>Essential</summary>

- [alacritty](https://github.com/alacritty/alacritty) - Terminal emulator.
- [thunar](https://packages.fedoraproject.org/pkgs/Thunar/Thunar/) - File manager.
- [blueman](https://packages.fedoraproject.org/pkgs/blueman/blueman/) - A tool to use Bluetooth devices. 
- [cups](https://packages.fedoraproject.org/pkgs/cups/cups/) - Print manager for Linux.
- [imv](https://packages.fedoraproject.org/pkgs/imv/imv/) - Image viewer for X11 and Wayland.
- [autotiling](https://github.com/nwg-piotr/autotiling) - Script for sway and i3 to automatically switch the horizontal & vertical window split orientation.
- [NetworkManager](https://packages.fedoraproject.org/pkgs/NetworkManager/NetworkManager/) - NetworkManager is a system service that manages network interfaces and connections.
- [nm-connection-editor](https://rpmfind.net/linux/rpm2html/search.php?query=nm-connection-editor&submit=Search+...&system=&arch=) - A network connection configuration editor for NetworkManager.
- [network-manager-applet](https://packages.fedoraproject.org/pkgs/network-manager-applet/network-manager-applet/) - Network control and status notification area applet for use with NetworkManager.
- [pipewire](https://packages.fedoraproject.org/pkgs/pipewire/pipewire/) - A multimedia server for Linux and other Unix like operating systems.
- [pipewire-alsa](https://packages.fedoraproject.org/pkgs/pipewire/pipewire-alsa/) - An ALSA plugin for the PipeWire media server.
- [ffmpeg-free](https://packages.fedoraproject.org/pkgs/ffmpeg/ffmpeg-free/) - A multimedia framework to record, convert and stream audio and video.
- [waybar](https://packages.fedoraproject.org/pkgs/waybar/waybar/) -  Status bar for Sway and Wlroots based compositors.
- [swaylock](https://packages.fedoraproject.org/pkgs/swaylock/swaylock/) - Lockscreen for Wayland compositors.
- [swaybg](https://packages.fedoraproject.org/pkgs/swaybg/swaybg/) - Wallpaper tool for Wayland compositors.
- [light](https://packages.fedoraproject.org/pkgs/light/light/) - Light is a program to control backlight.
- [fuzzel](https://packages.fedoraproject.org/pkgs/fuzzel/fuzzel/) - Wayland-native application launcher and fuzzy finder, inspired by rofi and dmenu.
- ~~[bemenu](https://packages.fedoraproject.org/pkgs/bemenu/bemenu/) - Dynamic menu inspired by dmenu.~~
- [wlogout](https://packages.fedoraproject.org/pkgs/wlogout/wlogout/) - A wayland based logout menu.
- [wdisplays](https://packages.fedoraproject.org/pkgs/wdisplays/wdisplays/) - A graphical application for configuring displays in Wayland compositors. 
- [wlroots](https://packages.fedoraproject.org/pkgs/wlroots/wlroots/) - A modular Wayland compositor library.
- [wf-recorder](https://packages.fedoraproject.org/pkgs/wf-recorder/wf-recorder/) - Screen recording utility for of wlroots-based compositors that support wlr-screencopy-v1 and xdg-output. 
- [grim](https://packages.fedoraproject.org/pkgs/grim/grim/) - Command-line tool to grab images from Sway. 
- [grimshot](https://packages.fedoraproject.org/pkgs/sway-contrib/grimshot/) - Screenshot utility for sway.
- [slurp](https://packages.fedoraproject.org/pkgs/slurp/slurp/) - Command-line tool that allows you to select a region on the screen and prints it to the standard output.
- [wl-clipboard](https://packages.fedoraproject.org/pkgs/wl-clipboard/wl-clipboard/) - Command-line Wayland clipboard utilities, `wl-copy` and `wl-paste`.
- [swaync](https://github.com/ErikReider/SwayNotificationCenter) - A notification daemon for SwayWM.
- [copyq](https://packages.fedoraproject.org/pkgs/copyq/copyq/) - Graphical clipboard manager.
- [NetworkManager-tui](https://packages.fedoraproject.org/pkgs/NetworkManager/NetworkManager-tui/) - NetworkManager-tui provides a text-based user interface for managing network connections in a non-graphical environment.
- [tuned](https://packages.fedoraproject.org/pkgs/tuned/tuned/) - A dynamic adaptive system tuning daemon.
- [tuned-ppd](https://packages.fedoraproject.org/pkgs/tuned/tuned-ppd/) - power-profiles-daemon compatibility daemon.
</details>

<details><summary>Customization</summary>

- [Nerd Fonts](https://www.nerdfonts.com/) - Iconic font aggregator, collection, and patcher.
  - Nerd Font used: FiraCode Nerd Font

<blockquote>
  <strong>Note:</strong> Nerd Font icons are used.
</blockquote>

- [Oh My Posh nordtron theme](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/nordtron.omp.json)
- [adwaita-icon-theme](https://github.com/GNOME/adwaita-icon-theme) - Icon set for GNOME core apps.
- [adw-gtk3-theme](https://packages.fedoraproject.org/pkgs/adw-gtk3-theme/adw-gtk3-theme/) - The theme from libadwaita ported to GTK-3. \
  [adw-gtk3 repository](https://github.com/lassekongo83/adw-gtk3)
  - **Install adw-gtk3 from Flatpak** \
    Stylize Flatpak applications *(Doesn't work with non-libadwaita GTK4 apps)*:
    ```console
    flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
    ```

</details>

## Disable Display Manager to Use TTY to Login

1. Check what display manager you're running:
    ```console
    systemctl status display-manager
    ```

2. Disable the display manager:
    ```console
    sudo systemctl disable <display_manager_name>.service
    ```

3. Copy & paste what's in [`.bash_profile`](https://github.com/hafiz-muhammad/configs/blob/main/linux/sway/home/.bash_profile) at the end of your `.bash_profile` file.

4. Reboot.

## Install Autotiling

Installation:
```console
pip install autotiling
```

## CUPS Installation and Enabling Service

CUPS admin web GUI: [http://localhost:631/](http://localhost:631/)
```console
sudo dnf install cups
sudo dnf install system-config-printer
sudo systemctl start cups.service
sudo systemctl enable cups.service
```

## Audio Output Issue Fix

If your audio output isn't switching correctly, delete `~/.local/state/wireplumber` and reboot.

## Open ports in firewalld for LocalSend
[Open ports in firewalld for LocalSend](https://github.com/hafiz-muhammad/configs/wiki/Fedora-General-Instructions#Open-ports-in-firewalld-for-LocalSend)
