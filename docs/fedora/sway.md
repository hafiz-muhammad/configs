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

## Install Optional Themes

- ### Nordic Theme

If `~/.themes` doesn't exist, create it.

Clone repository into `~/.themes`:
```console
cd ~/.themes
git clone https://github.com/EliverLara/Nordic ~/.themes/Nordic
```

- ### Adwaita-dark

If not already installed, run the following command:
```console
sudo dnf install gnome-themes-extra
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

