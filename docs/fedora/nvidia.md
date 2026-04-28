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

- [NVIDIA](https://fedoraproject.org/wiki/Hardware_Video_Acceleration#nVIDIA)
