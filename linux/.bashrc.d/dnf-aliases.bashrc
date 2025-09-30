# DNF package management
alias dnfup='sudo dnf update'
alias dnfup-ek='sudo dnf update --exclude=kernel*' # Update packages and exclude kernel updates
alias dnfin='sudo dnf install'
alias dnfrm='sudo dnf remove'
alias dnfup-rel='sudo dnf system-upgrade download --releasever="$1"' # Upgrade the release of Fedora
