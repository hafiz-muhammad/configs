## Enable [Flathub](https://flathub.org/home) on Fedora

```console
sudo dnf install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```


## Enable [RPM Fusion](https://rpmfusion.org/) Repositories

**Free Repository**
```console
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y && dnf upgrade -y
```

**Nonfree Repository**
```console
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && dnf upgrade -y
```

## Hardware Video Acceleration: VA-API

- [AMD](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#AMD)
- [Intel](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#Intel)

> [!NOTE]
> For NVIDIA-specific acceleration and driver setup, see [nvidia.md](https://github.com/hafiz-muhammad/configs/blob/main/docs/fedora/nvidia.md#hardware-video-acceleration-va-api).

## ClamAV Installation and Enabling Service

[Installing ClamAV](https://docs.clamav.net/manual/Installing.html#installing-clamav)
```console
sudo dnf upgrade --refresh
sudo dnf install clamav clamd clamav-update -y
sudo systemctl enable clamav-freshclam --now
sudo systemctl stop clamav-freshclam
```


## Fail2Ban Installation and Enabling Service

```console
sudo dnf install fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```


## How to Install and Configure profile-sync-daemon
More information on the [ArchWiki](https://wiki.archlinux.org/title/Profile-sync-daemon).

1. Install profile-sync-daemon:
    ```console
    sudo dnf install profile-sync-daemon
    ```

2. Create Psd configuration file by running the following command:
    ```console
    psd
    ```

3. Edit psd configuration file:
    ```console
    nano ~/.config/psd/psd.conf
    ```
   Look for the line labeled **BROWSERS** in the configuration file, remove the **#** symbol to uncomment it, and then include your browsers separated by spaces. (e.g. BROWSERS=(chromium firefox))

4. Enable and Start psd Service:
    ```console
    systemctl --user enable psd 
    reboot
    systemctl --user start psd
    ```

5. Verify psd Service is Started or Not:
    ```console
    systemctl --user status psd
    ```

## Open ports in firewalld for LocalSend
> [!NOTE]
> For my setup I find that this is needed for Fedora Sway Spin rather than Workstation. 

1. Check your active zone for firewalld
```console
sudo firewall-cmd --get-active-zones
```

2. Open the ports for LocalSend in your active zone (replace `public` if different)
```console
sudo firewall-cmd --zone=public --permanent --add-port=53317/tcp
sudo firewall-cmd --zone=public --permanent --add-port=53317/udp
```

3. Reload firewalld
```console
sudo firewall-cmd --reload
```

## AppImages Requiring FUSE to Run
Install
```console
dnf install fuse fuse-libs
```
