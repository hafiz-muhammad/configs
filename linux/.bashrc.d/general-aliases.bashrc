# Shortcuts
alias h='history'
alias hgrep='history | grep'
alias clr='clear'

# List all files in long format including hidden files
alias lla='ls -la'

# Count the number files in a directory
alias count='find . -type f | wc -l'

# Make and change directory at once
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'

# Clears command history and terminal screen for current shell session
alias vanish='history -c && clear'

# Removes bash history file and clears command history for current shell session
alias vanishall='rm -f ~/.bash_history && history -c'

