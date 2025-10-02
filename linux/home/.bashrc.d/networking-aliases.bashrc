# Network ports
alias allports='netstat -tulanp'
alias listenports='netstat -tulanp | grep LISTEN'

# NetworkManager control
# Needs NetworkManager package to be installed
alias nwon='nmcli networking on'
alias nwoff='nmcli networking off'

# IPv4 & IPv6 lookup
alias pubipv4='dig TXT CH +short whoami.cloudflare @1.1.1.1  | tr -d "\""'
alias pubipv6='dig TXT CH +short whoami.cloudflare @2606:4700:4700::1111  | tr -d "\""'

