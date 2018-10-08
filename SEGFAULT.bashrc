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

if [ -f /usr/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    source /usr/bin/virtualenvwrapper.sh
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

# Fucking Computers
alias shit='sudo $(history -p !!)'

# Because ll doesn't roll off the tounge that nicely
alias ls="ls -l --color"

# Because I always feel more badass typing "logout"
alias logout="exit"

# Get the location of this script file
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Puts git in your prompt
function __git_eread ()
{ 
    local f="$1";
    shift;
    test -r "$f" && read "$@" < "$f"
}

# Custom compiler setups
function  gccc(){
     gcc -g -Wall -ansi -lm -o $1.out $1
    }


# Git tree view
function git() {
    if [[ $1 == "tree" ]]; then
        command git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
    else
        command git "$@"
    fi
}

function __git_ps1 () { 
    local exit=$?;
    local pcmode=no;
    local detached=no;
    local ps1pc_start='\u@\h:\w ';
    local ps1pc_end='\$ ';
    local printf_format=' (%s)';
    case "$#" in 
        2 | 3)
            pcmode=yes;
            ps1pc_start="$1";
            ps1pc_end="$2";
            printf_format="${3:-$printf_format}";
            PS1="$ps1pc_start$ps1pc_end"
        ;;
        0 | 1)
            printf_format="${1:-$printf_format}"
        ;;
        *)
            return $exit
        ;;
    esac;
    local ps1_expanded=yes;
    [ -z "$ZSH_VERSION" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no;
    [ -z "$BASH_VERSION" ] || shopt -q promptvars || ps1_expanded=no;
    local repo_info rev_parse_exit_code;
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir 		--is-bare-repository --is-inside-work-tree 		--short HEAD 2>/dev/null)";
    rev_parse_exit_code="$?";
    if [ -z "$repo_info" ]; then
        return $exit;
    fi;
    local short_sha;
    if [ "$rev_parse_exit_code" = "0" ]; then
        short_sha="${repo_info##*
}";
        repo_info="${repo_info%
*}";
    fi;
    local inside_worktree="${repo_info##*
}";
    repo_info="${repo_info%
*}";
    local bare_repo="${repo_info##*
}";
    repo_info="${repo_info%
*}";
    local inside_gitdir="${repo_info##*
}";
    local g="${repo_info%
*}";
    if [ "true" = "$inside_worktree" ] && [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] && [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] && git check-ignore -q .; then
        return $exit;
    fi;
    local r="";
    local b="";
    local step="";
    local total="";
    if [ -d "$g/rebase-merge" ]; then
        __git_eread "$g/rebase-merge/head-name" b;
        __git_eread "$g/rebase-merge/msgnum" step;
        __git_eread "$g/rebase-merge/end" total;
        if [ -f "$g/rebase-merge/interactive" ]; then
            r="|REBASE-i";
        else
            r="|REBASE-m";
        fi;
    else
        if [ -d "$g/rebase-apply" ]; then
            __git_eread "$g/rebase-apply/next" step;
            __git_eread "$g/rebase-apply/last" total;
            if [ -f "$g/rebase-apply/rebasing" ]; then
                __git_eread "$g/rebase-apply/head-name" b;
                r="|REBASE";
            else
                if [ -f "$g/rebase-apply/applying" ]; then
                    r="|AM";
                else
                    r="|AM/REBASE";
                fi;
            fi;
        else
            if [ -f "$g/MERGE_HEAD" ]; then
                r="|MERGING";
            else
                if [ -f "$g/CHERRY_PICK_HEAD" ]; then
                    r="|CHERRY-PICKING";
                else
                    if [ -f "$g/REVERT_HEAD" ]; then
                        r="|REVERTING";
                    else
                        if [ -f "$g/BISECT_LOG" ]; then
                            r="|BISECTING";
                        fi;
                    fi;
                fi;
            fi;
        fi;
        if [ -n "$b" ]; then
            :;
        else
            if [ -h "$g/HEAD" ]; then
                b="$(git symbolic-ref HEAD 2>/dev/null)";
            else
                local head="";
                if ! __git_eread "$g/HEAD" head; then
                    return $exit;
                fi;
                b="${head#ref: }";
                if [ "$head" = "$b" ]; then
                    detached=yes;
                    b="$(
				case "${GIT_PS1_DESCRIBE_STYLE-}" in
				(contains)
					git describe --contains HEAD ;;
				(branch)
					git describe --contains --all HEAD ;;
				(describe)
					git describe HEAD ;;
				(* | default)
					git describe --tags --exact-match HEAD ;;
				esac 2>/dev/null)" || b="$short_sha...";
                    b="($b)";
                fi;
            fi;
        fi;
    fi;
    if [ -n "$step" ] && [ -n "$total" ]; then
        r="$r $step/$total";
    fi;
    local w="";
    local i="";
    local s="";
    local u="";
    local c="";
    local p="";
    if [ "true" = "$inside_gitdir" ]; then
        if [ "true" = "$bare_repo" ]; then
            c="BARE:";
        else
            b="GIT_DIR!";
        fi;
    else
        if [ "true" = "$inside_worktree" ]; then
            if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] && [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
                git diff --no-ext-diff --quiet --exit-code || w="*";
                if [ -n "$short_sha" ]; then
                    git diff-index --cached --quiet HEAD -- || i="+";
                else
                    i="#";
                fi;
            fi;
            if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] && git rev-parse --verify --quiet refs/stash > /dev/null; then
                s="$";
            fi;
            if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] && [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] && git ls-files --others --exclude-standard --error-unmatch -- ':/*' > /dev/null 2> /dev/null; then
                u="%${ZSH_VERSION+%}";
            fi;
            if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
                __git_ps1_show_upstream;
            fi;
        fi;
    fi;
    local z="${GIT_PS1_STATESEPARATOR-" "}";
    if [ $pcmode = yes ] && [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
        __git_ps1_colorize_gitstring;
    fi;
    b=${b##refs/heads/};
    if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
        __git_ps1_branch_name=$b;
        b="\${__git_ps1_branch_name}";
    fi;
    local f="$w$i$s$u";
    local gitstring="$c$b${f:+$z$f}$r$p";
    if [ $pcmode = yes ]; then
        if [ "${__git_printf_supports_v-}" != yes ]; then
            gitstring=$(printf -- "$printf_format" "$gitstring");
        else
            printf -v gitstring -- "$printf_format" "$gitstring";
        fi;
        PS1="$ps1pc_start$gitstring$ps1pc_end";
    else
        printf -- "$printf_format" "$gitstring";
    fi;
    return $exit
}

monitor() {
    SESSION="__HWMON"

    if tmux has-session -t $SESSION; then
        tmux -2 attach-session -t $SESSION
        return
    fi


    if [  -z ${TMUX+x} ]; then # This tests if the variable is empty
        tmux -2 new-session -d -s $SESSION
        tmux new-window -t $SESSION:1 -n 'HWMon'&
        PANE='0'
    else
        PANE=$TMUX_PANE
    fi

    tmux split-window -h
    tmux send-keys "htop" C-m
    if command -v nvidia-smi >/dev/null; then
        tmux split-window -v
        tmux send-keys "watch -n 0.2 nvidia-smi" C-m
    fi
    tmux select-pane -t $PANE
    tmux send-keys "watch -n 0.2 sensors" C-m
    tmux split-window -v
    tmux send-keys "dmesg -w" C-m

    if [  -z ${TMUX+x} ]; then
        # Set default window
        tmux select-window -t $SESSION:1
        # Attach to session
        tmux -2 attach-session -t $SESSION
    fi
}

# Latest next gen video game
echo $(tput bold) "Welcome to Terminal Simulator" $(date +%Y) $(tput sgr0)

__C_Black="\[\033[0;30m\]"
__C_DarkGray="\[\033[1;30m\]"
__C_Blue="\[\033[0;34m\]"
__C_LightBlue="\[\033[1;34m\]"
__C_Green="\[\033[0;32m\]"
__C_LightGreen="\[\033[1;32m\]"
__C_Cyan="\[\033[0;36m\]"
__C_LightCyan="\[\033[0;36m\]"
__C_Red="\[\033[0;31m\]"
__C_LightRed="\[\033[1;31m\]"
__C_Purple="\[\033[0;35m\]"
__C_LightPurple="\[\033[1;35m\]"
__C_Brown="\[\033[0;33m\]"
__C_Yellow="\[\033[1;33m\]"
__C_LightGray="\[\033[0;37m\]"
__C_White="\[\033[1;37m\]"
__C_Reset="\[\033[0m\]"
__C_HOST="\[\033[32;38;5;$((0x$(hostname | md5sum | cut -f1 -d' ' | tr -d '\n' | tail -c2)))m\]"


if [ ${USER} == "root" ]; then
    PS1="[${__C_LightBlue}\A ${__C_Red}\u${__C_Reset}@${__C_HOST}\h ${__C_Cyan}\W${__C_Brown}\$(__git_ps1 \" (%s)\")${__C_Reset}]# "
else
    PS1="[${__C_LightBlue}\A ${__C_Green}\u${__C_Reset}@${__C_HOST}\h ${__C_Cyan}\W${__C_Brown}\$(__git_ps1 \" (%s)\")${__C_Reset}]$ "
fi

#This adds the inner scripts dir to the path so we can call them
export PATH="$PATH:${SRC_DIR}/scripts"
