# Directory navigation
alias ..='cd ..;pwd'
alias ...='cd ../..;pwd'
alias ....='cd ../../..;pwd'
alias .....='cd ../../../..;pwd'
alias ~='cd ~'
alias dl='cd ~/Downloads'
alias back='cd $OLDPWD'

# Filesystem safeguards
#
# Confirm when removing, copying, linking, moving
#alias rm='rm -i'
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
