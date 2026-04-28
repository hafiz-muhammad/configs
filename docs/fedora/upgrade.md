## Upgrade Fedora to Latest Version

Links to official documentation

- [Upgrading Fedora Linux to a New Release](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-new-release/)
- [Upgrading Fedora Linux Using DNF System Plugin](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-offline/)
- [Upgrading Fedora Linux Online Using Package Manager](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-online/)

### Performing the Upgrade

**1.** Confirm the active release version:
```console
cat /etc/fedora-release
```
Verify the system's release macro:
```console
rpm -E %fedora
```

**2.** Ensure your system is fully updated:
```console
sudo dnf upgrade --refresh
sudo reboot
```

**3.** Install upgrade plugin if missing:
```console
sudo dnf install dnf-plugin-system-upgrade
```

**4.** Download packages for target release. Replace `<version_number>` with the actual version number for the new release.
```console
sudo dnf system-upgrade download --releasever=<version_number>
```

**(if needed)** - *run the below command so DNF can remove conflicting packages*

```console
sudo dnf system-upgrade download --releasever=<version_number> --allowerasing
```

**5.** The system will reboot into a special upgrade environment once the download is finished

> [!CAUTION]
> Do not interrupt the upgrade. Ensure the system remains powered on until the process finishes.

For DNF5 run:
```console
sudo dnf5 offline reboot
```

Cancel the upgrade and delete downloaded files:
```console
sudo dnf5 offline clean
```

For DNF4 run:
```console
sudo dnf system-upgrade reboot
```

### Post-Upgrade Maintenance

**1.** Confirm the active release version:
```console
cat /etc/fedora-release
```
Verify the system's release macro:
```console
rpm -E %fedora
```

**2.** Remove retired packages

Install the `remove-retired-packages` utility and run it to clean up packages that are no longer maintained in the new release repositories.
```console
sudo dnf install remove-retired-packages
remove-retired-packages
```

**For upgrades across two releases:** \
If you skipped a version (e.g., upgrading from Fedora 42 to 44), you must specify the old release version number.

```console
sudo dnf install remove-retired-packages
remove-retired-packages <old_release_version>
```

> [!NOTE]
> Upgrades across more than two releases are not supported. 

**3.** Synchronize installed packages:
```console
sudo dnf distro-sync
```

**4.** Remove leftover packages:
```console
sudo dnf autoremove
```
