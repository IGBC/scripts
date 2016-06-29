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
eval $(thefuck --alias)

# Actual user stuff

# "cd" then "ls" function
function change_and_list {
	ls $@ -l --color
	cd $1
}

# Because ll doesn't roll off the tounge that nicely
alias ls="ls -l --color"

# Because I always feel more badass typing "logout"
alias logout="exit"

# "cl" is shorter than "cd && ls" 
alias cl="change_and_list"

# Because fucking DNF
alias doit="sudo !!"

# Latest next gen video game
echo $(tput bold) "Welcome to Terminal Simulator" $(date +%Y) $(tput sgr0)
