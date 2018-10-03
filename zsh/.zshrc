# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
#setopt autocd extendedglob nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/vivek/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# source ~/.zprofile

alias ls='ls --color'
alias grep='grep --color=auto'
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"
}

export VISUAL="nvim"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
#export GDK_SCALE=1.75
#export GDK_DPI_SCALE=1.5
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
alias xmerge='xrdb -merge ~/.Xresources'
alias aupdate='antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh'
alias keil='wine "C:\Keil\UV4\UV4.exe"'
alias pakku='sudo pakku'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias vim='nvim'
alias vi='nvim'
export TERMINAL="urxvt"
export IDF_PATH=~/.esp-idf-sdk

#transfer
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
    tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

    source ~/.zsh_plugins.sh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    #GPG
    export GPG_TTY=$(tty)
    # [ -f ~/.gnupg/gpg-agent-info ] && source ~/.gnupg/gpg-agent-info
    # if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
    #    export GPG_AGENT_INFO
    # else
    #    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf)
    #fi
    #test1
