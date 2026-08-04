# Set secure permissions on a file
secperms() {
    if [ -z "$1" ]; then
        echo "Usage: secperms <filename>"
        return 1
    fi

    chmod 600 "$1" && chown --preserve-root "$USER:$USER" "$1"
    echo "Secure permissions applied to $1"
}

# Upgrade Fedora to a new release
fedora-upgrade() {
    if [ -z "$1" ]; then
        echo "Usage: fedora-upgrade <releasever>"
        echo "Example: fedora-upgrade 43"
        return 1
    fi

    local releasever="$1"

    sudo dnf system-upgrade download --releasever="$releasever" --allowerasing
    sudo dnf5 offline reboot
}
