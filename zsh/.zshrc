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
source ~/.zprofile
source /opt/ros/lunar/setup.zsh
source ~/catkin_ws/devel/setup.zsh
source $(dirname $(gem which colorls))/tab_complete.sh
#alias ls='colorls'
alias ls='ls --color'
alias xmerge='xrdb -merge ~/.Xresources'
alias aupdate='antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh'
#alias python='python3'
#alias python2='/usr/bin/python'
alias keil='wine "C:\Keil\UV4\UV4.exe"'

export TERMINAL="urxvt"

#transfer
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

source ~/.zsh_plugins.sh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
