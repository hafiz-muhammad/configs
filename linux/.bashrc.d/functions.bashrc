# Set secure permissions on a file
secperms() {
    if [ -z "$1" ]; then
        echo "Usage: secperms <filename>"
        return 1
    fi

    chmod 600 "$1" && chown --preserve-root "$USER:$USER" "$1"
    echo "Secure permissions applied to $1"
}


