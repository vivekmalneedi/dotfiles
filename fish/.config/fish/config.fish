set -gx MOZ_ENABLE_WAYLAND 1
set fish_greeting

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
    end
end

# colors
set LESS -R
set LESS_TERMCAP_mb '\E[1;31m'     # begin blink
set LESS_TERMCAP_md '\E[1;36m'     # begin bold
set LESS_TERMCAP_me '\E[0m'        # reset bold/blink
set LESS_TERMCAP_so '\E[01;44;33m' # begin reverse video
set LESS_TERMCAP_se '\E[0m'        # reset reverse video
set LESS_TERMCAP_us '\E[1;32m'     # begin underline
set LESS_TERMCAP_ue '\E[0m'        # reset underline

source ~/.config/fish/backblaze.fish
source ~/.config/fish/private.fish

# aliases
alias paru="paru --sudoloop"
alias ls="exa"

zoxide init fish | source
starship init fish | source
