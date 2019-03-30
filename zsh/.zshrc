HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/vivek/.zshrc'
autoload -Uz compinit
compinit

#options
setopt autocd
setopt globdots
setopt histignoredups
setopt noclobber

# colored ouput
alias ls='ls --color'
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

#variables
export VISUAL="nvim"
export EDITOR="nvim"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2
export GDK_DPI_SCALE=1.5
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
alias xmerge='xrdb -merge ~/.Xresources'
alias abupdate='antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh'
alias aupdate='antibody update'
alias keil='wine "C:\Keil\UV4\UV4.exe"'
alias pakku='sudo pakku'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias gpucheck='cat /proc/acpi/bbswitch'
alias gpuoff='sudo tee /proc/acpi/bbswitch <<<OFF'
alias lstrash='ls ~/.local/share/Trash/files'
alias emptytrash='rm -r ~/.local/share/Trash/files/*'
alias clean='yay -Scc'
alias yayu='yay --answerupgrade None --answeredit None --answerdiff None --answerclean None -Syu'
alias find='fd'
alias grep='rg'
alias vi='nvim'
alias vim='nvim'
export TERMINAL="urxvtcd"
export IDF_PATH=~/esp/esp-idf
export PATH="/usr/lib/ccache/bin/:$PATH"
export GPG_TTY=$(tty)
export AUTO_LS_COMMANDS=(ls)
alias f='cd $(fd -H -E "*{.git,.mozilla,misc,windows,.cache}*" -t f -t l -t d . '/home' | fzy)'
alias n='nvim $(fd -H -E "*{.git,.mozilla,misc,windows,.cache}*" -t f -t l -t d . '/home' | fzy)'
alias checkout='git checkout $(git branch | cut -c 3- | fzy)'

source ~/.zsh_plugins.sh

#functions
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
    tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

function yta() {
    mpv --ytdl-format=bestaudio ytdl://ytsearch:"$@"
}

function mpy() {
    mpv --ytdl-format=bestaudio --loop "$@"
}

function pname() {
    ps -p "$@" -o command
}

function decode() {
    echo "$@" | base64 --decode
}

# Codi
# Usage: codi [filetype] [filename]
function codi() {
  local syntax="${1:-python}"
  shift
  nvim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}

function pdfmerge() {
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@
}


#keybinds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word
bindkey "\e[3~" delete-char
