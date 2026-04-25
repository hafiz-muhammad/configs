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


## IMPORTANT! MOK & NVIDIA Drivers: Secure Boot
> [!CAUTION]
> Make sure your Machine Owner Key (MOK) is enrolled first; then install the NVIDIA driver using that key, or the NVIDIA kernel module will not be accepted by Secure Boot.

- [Fedora Project Docs - Machine Owner Key Enrollment](https://docs.fedoraproject.org/en-US/quick-docs/mok-enrollment/)
- [RPM Fusion - Howto/Secure Boot](https://rpmfusion.org/Howto/Secure%20Boot)

### 1. Machine Owner Key Enrollment

**1a.** Install the following:
```console
sudo dnf install kmodtool akmods mokutil openssl
```

**1b.** Generate a default value key:
```console
sudo kmodgenca -a 
```

**1c.** Request enrollment of the new key by importing its certificate:
```console
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
```
**Mokutil will ask to create a password for public key enrollment. Make note of the new password that you set.**

**1d.** Reboot system:
```console
systemctl reboot
```

> [!IMPORTANT]
> - After you reboot you will be presented with a blue screen to perform MOK management, you'll enroll MOK from here.
> - Press any key to continue.
> - Select `Enroll MOK`
> - Select `Continue`
> - Select `Yes` to enroll the key.
> - Next type the password that you created for the key then press `Enter`.
> - Select `Reboot`

> [!NOTE]
> When updating BIOS/EFI you may need to reimport the Secure Boot key. \
> Use the following command to reimport: \
> ```console sudo mokutil --import /etc/pki/akmods/certs/public_key.der```


### 2. Install NVIDIA Drivers
*Be sure you have installed RPM fusion repositories as mentioned in the previous instructions*

**2a.** Install NVIDIA proprietary drivers:
```console
sudo dnf install akmod-nvidia
```

**2b.** If you need CUDA support, install CUDA libraries:
```console
sudo dnf install xorg-x11-drv-nvidia-cuda
```

**2c.** Reboot system:
```console
sudo reboot
```


## Hardware Video Acceleration: VA-API

- [AMD](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#AMD)
- [Intel](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#Intel)
- [NVIDIA](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#nVIDIA)


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