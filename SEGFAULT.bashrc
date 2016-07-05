######################################
#   .bashrc  for  SEGFAULT  (IGBC)   #
#   Warning this file may contain    #
#   Strong Language, strange humour  #
#   And   Bad   Linux   Hacks        #
#                                    #
#   This software is free to use     #
#   and disurubute as you see fit    #
#                                    #
#   No Warranty... Etc, Etc...       #
######################################

# Source global definitions (Fedora does this)
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# this is for the "fuck" command
if command -v thefuck >/dev/null; then
    eval $(thefuck --alias)
fi

# Actual user stuff

# "cd" then "ls" function
function cl() {
	cd $1
	ls $@ -l --color
}

# More useful root
function sudo() {
    if [[ $@ == "-i" ]]; then
        # if interactive then fire up a new bash session, and push this file to it
        command sudo bash --rcfile $HOME/.bashrc
    else
        command sudo "$@"
    fi
}

# Because ll doesn't roll off the tounge that nicely
alias ls="ls -l --color"

# Because I always feel more badass typing "logout"
alias logout="exit"

# Because fucking DNF
alias doit="sudo !!"

# Latest next gen video game
echo $(tput bold) "Welcome to Terminal Simulator" $(date +%Y) $(tput sgr0)
