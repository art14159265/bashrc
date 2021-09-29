#
# /etc/bash.bashrc
#
# If not running interactively, don't do anything

[[ $- != *i* ]] && return


# alias hideme='history -d $((HISTCMD-1))'
# alias hideprev='history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))'

HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%Y.%m.%d %T "
HISTIGNORE='ls:kdevelop*:history*'
HISTCONTROL='ignoreboth:erasedup'

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize
shopt -s autocd
shopt -s extglob

# PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

if [ "$UID" != 0 ]; then
        archey3
	PS1='\[\e[0;32m\][\u@\h \[\e[1;33m\]\w\[\e[0;32m\]]\[\e[1;32m\]\$\[\e[0m\] '
else
	PS1='\[\e[0;31m\][\u@\h \[\e[1;33m\]\w\[\e[0;31m\]]#\[\e[0m\] '
fi

PS2='> '
PS3='> '
PS4='+ '

# source /usr/share/doc/pkgfile/command-not-found.bash

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

function extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

function cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	else
		echo "bash: cl: $dir: Directory not found"
	fi
}

function swap() { 
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

bind '"\e[1;5A": history-search-backward'
bind '"\e[1;5B": history-search-forward'

bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'

bind '"\eh": "\C-a\eb\ed\C-y\e#man \C-y\C-m\C-p\C-p\C-a\C-d\C-e"'

# bind 'set bell-style audible'
bind 'set menu-complete-display-prefix on'

# bind 'set page-completions off'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set completion-map-case on'

bind 'set mark-directories on'
bind 'set mark-symlinked-directories on'
bind 'set visible-stats on'
# bind 'set completion-query-items 9001'

## Modified commands
alias diff='colordiff'
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias dmesg='dmesg -HL'

# 
alias hist='history && history -d $((HISTCMD-1))'
# Alias to multiple ls commands
alias la='ls -Al'                # show hidden files
alias ls='ls -aF --color=always' # add colors and file type extensions
alias lx='ls -lXB'               # sort by extension
alias lk='ls -lSr'               # sort by size
alias lc='ls -lcr'               # sort by change time 
alias lu='ls -lur'               # sort by access time   
alias lr='ls -lR'                # recursive ls
alias lt='ls -ltr'               # sort by date
alias lm='ls -al | more'         # pipe through 'more'

# alias hist='history | grep $1' #Requires one input
alias ps='ps auxf'
alias home='cd ~'
alias pg='ps aux | grep'  #requires an argument
alias mountedinfo='df -hT'
alias openports='netstat -nape --inet'
alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias da='date "+%Y-%m-%d %A	%T %Z"'
alias webshare='python3 -m http.server'

alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du1='du -h --max-depth=1'
