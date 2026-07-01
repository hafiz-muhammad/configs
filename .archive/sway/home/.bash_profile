# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

##################################################
# User specific environment and startup programs #
##################################################

# If running from tty1 start sway
[ "$(tty)" = "/dev/tty1" ] && exec sway
