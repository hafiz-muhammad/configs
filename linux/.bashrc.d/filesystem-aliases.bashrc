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
#alias rm='rm -i --preserve-root' # Confirm when removing and protect root directory
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
#
# Protect changing permissions in root directory
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
#
# Make a file immutable
alias mkimm='sudo chattr +i'
#
# Remove the immutable attribute from a file
alias rmimm='sudo chattr -i'
