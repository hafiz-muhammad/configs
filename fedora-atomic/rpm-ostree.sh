#!/usr/bin/env bash
set -e

PACKAGES=(
  brave-browser
  lm_sensors
)

# Detect GNOME via active desktop session or installed gnome-shell
if [[ "${XDG_CURRENT_DESKTOP:-}" =~ "GNOME" ]] || command -v gnome-shell &>/dev/null; then
  echo "GNOME detected! Adding gnome-tweaks to list..."
  PACKAGES+=(gnome-tweaks)
else
  echo "Non-GNOME environment detected. Skipping gnome-tweaks."
fi

# Add Brave repository for Fedora Atomic desktops if missing
if [ ! -f /etc/yum.repos.d/brave-browser.repo ]; then
  echo "Configuring Brave Browser repository..."
  run0 curl -fsSLo /etc/yum.repos.d/brave-browser.repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi

TO_INSTALL=()

# Filter out packages that are already layered
for pkg in "${PACKAGES[@]}"; do
  if ! rpm -q "$pkg" &>/dev/null; then
    TO_INSTALL+=("$pkg")
  fi
done

# Layer missing packages in a single transaction
if [ ${#TO_INSTALL[@]} -gt 0 ]; then
  echo "Layering packages: ${TO_INSTALL[*]}..."
  rpm-ostree install -y "${TO_INSTALL[@]}"
  echo "Packages layered successfully! A system reboot is required to apply changes."
else
  echo "All requested packages are already layered."
fi
