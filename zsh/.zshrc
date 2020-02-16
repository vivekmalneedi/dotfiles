HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
zstyle :compinstall filename '/home/vivek/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

#options
setopt autocd
setopt globdots
setopt histignoredups
setopt noclobber
# no c-s/c-q output freezing
setopt noflowcontrol
# allow expansion in prompts
# setopt prompt_subst
# this is default, but set for share_history
setopt append_history
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
# display PID when suspending processes as well
setopt longlistjobs
# try to avoid the 'zsh: no matches found...'
setopt nonomatch
# report the status of backgrounds jobs immediately
setopt notify
# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# use zsh style word splitting
setopt noshwordsplit
# allow use of comments in interactive code
setopt interactivecomments

# colored ouput
alias ls='ls --color'
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"
}


#Aliases
alias xmerge='xrdb -merge ~/.Xresources'
alias keil='wine "C:\Keil\UV4\UV4.exe"'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias gpucheck='cat /proc/acpi/bbswitch'
# alias gpuoff='sudo Desktop/disablegpu.sh'
alias gpuoff='sudo tee /proc/acpi/bbswitch <<<OFF'
# alias gpuon='sudo Desktop/enablegpu.sh'
alias clean='yay -Scc'
alias yayu='yay --answerupgrade None --answeredit None --answerdiff None --answerclean Nonr --sudoloop --noremovemake -Syu'
alias yay='yay --editor nvim --editmenu --sudoloop'
alias find='fd'
alias grep='rg'
alias f='cd $(fd -H -E "*{.git,.mozilla,misc,windows,.cache}*" -t f -t l -t d . '/home' | fzy)'
alias n='nvim $(fd -H -E "*{.git,.mozilla,misc,windows,.cache}*" -t f -t l -t d . '/home' | fzy)'
alias checkout='git checkout $(git branch | cut -c 3- | fzy)'
alias cp='advcp -g'
alias mv='advmv -g'
alias youtube-dl='youtube-dl -f best'
alias mpy='mpv --ytdl-format=bestaudio --loop'
alias clamscan='clamdscan --multiscan --fdpass'
alias vim="nvim"
alias vi="nvim"

#functions
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
    tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

function mpy() {
    mpv --ytdl-format=bestaudio --loop "$@"
}

function pname() {
    ps -p "$@" -o command
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

# Usage: pdfmerge [output] [inputs]
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

### Added by Zplugin's installer
source '/home/vivek/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

# colors
zplugin ice lucid wait'0' atclone"dircolors -b LS_COLORS > clrs.zsh" atpull'%atclone' pick"clrs.zsh"
zplugin light trapd00r/LS_COLORS
zplugin ice lucid wait'0'
zplugin light zpm-zsh/colors #various utility colorization
zplugin ice lucid wait'0'
zplugin light ael-code/zsh-colored-man-pages
zplugin ice lucid wait'0'
zplugin light chrissicool/zsh-256color

#general plugins
zplugin ice lucid wait'0'
zplugin light desyncr/auto-ls
zplugin light Tarrasch/zsh-command-not-found #suggests command if not found
zplugin ice lucid wait'0'
zplugin light marzocchi/zsh-notify #notifications for long running programs
zplugin ice lucid wait'0'
zplugin light twang817/zsh-clipboard #cli clipboard interaction
# PS1="➜"
PS1=">"
# zplugin light denysdovhan/spaceship-prompt
# zplugin ice lucid wait'0'
zplugin light hlissner/zsh-autopair
zplugin ice lucid wait'0'
zplugin light oz/safe-paste
zplugin ice from'gh-r' as'program'
zplugin light sei40kr/fast-alias-tips-bin
zplugin light sei40kr/zsh-fast-alias-tips
zplugin ice lucid wait'0'
zplugin light zdharma/zui
zplugin ice lucid wait'0'
zplugin light zdharma/zplugin-crasis

#git
zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)gi*]} ]]' as"program" pick"bin/git-dsf"
zplugin light zdharma/zsh-diff-so-fancy
zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)gi*]} ]]' pick'init.zsh' blockf
zplugin light laggardkernel/git-ignore
zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)gi*]} ]]'
zplugin light peterhurford/git-aliases.zsh
zplugin ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)gi*]} ]]'
zplugin light rapgenic/zsh-git-complete-urls

#plugin aliases/settings
alias gi="git-ignore"

#OMZ
zplugin ice lucid wait'0'
zplugin snippet OMZ::plugins/archlinux/archlinux.plugin.zsh
zplugin ice lucid wait'0' as'completion' blockf
zplugin snippet OMZ::plugins/ripgrep/_ripgrep
zplugin ice lucid wait'0'
zplugin snippet OMZ::plugins/systemd/systemd.plugin.zsh
zplugin ice lucid wait'0'
zplugin snippet OMZ::plugins/encode64/encode64.plugin.zsh
zplugin ice lucid wait'0'
zplugin snippet OMZ::plugins/screen/screen.plugin.zsh
zplugin ice lucid wait'0'
zplugin snippet OMZ::lib/completion.zsh

# completion
zplugin ice lucid wait'0' blockf
zplugin light srijanshetty/zsh-pandoc-completion
zplugin ice lucid wait'0' as'completion' blockf
zplugin light zpm-zsh/ssh
zplugin ice lucid wait'0' pick"_urls" as'completion' blockf
zplugin light Valodim/zsh-_url-httplink
zplugin ice lucid wait'0' pick'_pip' as'completion' blockf
zplugin light srijanshetty/zsh-pip-completion
zplugin ice lucid wait'0' atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions
zplugin ice lucid wait'0' blockf
zplugin light zsh-users/zsh-completions
zplugin ice lucid wait'0'
zplugin light zsh-users/zsh-history-substring-search
zplugin ice lucid wait'0' blockf
zplugin light fnoris/keybase-zsh-completion
# zplugin ice lucid wait'0' blockf
# zplugin snippet https://github.com/beetbox/beets/blob/master/extra/_beet

zplugin ice lucid wait'1' atinit'zpcompinit; zpcdreplay'
zplugin light zdharma/fast-syntax-highlighting

autoload -Uz compinit
compinit

export MAKEFLAGS="-j $(nproc)"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export PATH="${PATH}:/home/vivek/Documents/tm4c-llvm-toolchain"
export PATH="${PATH}:/home/vivek/.cargo/bin"
export PATH="${PATH}:/home/vivek/.local/bin"
# export WINEPREFIX=~/.wine64
# export WINEARCH=win64

eval "$(starship init zsh)"
