#!/usr/bin/env bash
set -e

if ! flatpak remotes --user | grep -q "^flathub"; then
  echo "Adding Flathub repository..."
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
  echo "Flathub repository already configured."
fi

FLATPAKS=(
    # Logseq (Privacy-first knowledge base / note-taking app)
    com.logseq.Logseq

    # Warehouse (Flatpak manager)
    io.github.flattool.Warehouse

    # KeePassXC (Password manager)
    org.keepassxc.KeePassXC

    # Passwords and Keys / Seahorse (Passwords and encryption key manager)
    org.gnome.seahorse.Application

    # Authenticator (Two-factor authentication / 2FA)
    com.belmoussaoui.Authenticator

    # Thunderbird ESR (Email client - extended support release)
    org.mozilla.thunderbird_esr

    # LibreOffice (Office suite)
    org.libreoffice.LibreOffice

    # GIMP (Image editor)
    org.gimp.GIMP

    # Inkscape (Vector graphics editor)
    org.inkscape.Inkscape

    # Apostrophe (Markdown editor)
    org.gnome.gitlab.somas.Apostrophe

    # Errands (Todo list manager)
    io.github.mrvladus.List

    # Embellish (Nerd fonts manager)
    io.github.getnf.embellish

    # Flatseal (Flatpak permission manager)
    com.github.tchx84.Flatseal

    # LocalSend (Local network file sharing)
    org.localsend.localsend_app

    # PulseAudio Volume Control (pavucontrol)
    org.pulseaudio.pavucontrol

    # VLC (Media player)
    org.videolan.VLC

    # qBittorrent (Torrent client)
    org.qbittorrent.qBittorrent

    # Cryptomator (Cloud file encryption)
    org.cryptomator.Cryptomator

    # Blanket (Ambient noise player)
    com.rafaelmardojai.Blanket

    # Amberol (Music player)
    io.bassi.Amberol

    # Web App Hub (Web app manager)
    org.pvermeer.WebAppHub

    # SyncThingy (Syncthing + simple tray indicator)
    com.github.zocker_160.SyncThingy

    # Mission Center (System resource monitor)
    io.missioncenter.MissionCenter

    # Spotify (Music streaming service)
    com.spotify.Client

    # SimpleX Chat (Private & encrypted open-source messenger)
    chat.simplex.simplex

    # Session (Private messenger)
    network.loki.Session

    # Tuba (Browse the Fediverse)
    dev.geopjr.Tuba

    # Zotero (Reference management software)
    org.zotero.Zotero
)

TO_INSTALL=()

for app in "${FLATPAKS[@]}"; do
  if ! flatpak info --user "$app" &>/dev/null; then
    TO_INSTALL+=("$app")
  fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
  echo "Installing Flatpak applications..."
  for app in "${TO_INSTALL[@]}"; do
    flatpak install --user --assumeyes flathub "$app" || echo "Failed to install $app"
  done
  echo "Flatpak installation complete!"
else
  echo "All Flatpaks are already installed."
fi
