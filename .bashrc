#
# ~/.bashrc
#

include() {
  test -f "$1" && . "$@"
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# Check the terminal size when bash regains control
shopt -s checkwinsize

shopt -s expand_aliases

# Enable history appending instead of overwriting.
shopt -s histappend

# Starship
eval "$(starship init bash)"

# nvm
# source /usr/share/nvm/init-nvm.sh

# fuck
# eval "$(thefuck --alias)"

# pat.hs
source /usr/share/paths/paths.sh

# complete alias
source /usr/share/bash-complete-alias/complete_alias

export VISUAL="nvim"
export EDITOR="$VISUAL"
export SUDO_ASKPASS=/usr/bin/xaskpass

alias vim="nvim"
alias ls="exa --long --color=auto"
alias la="ls -a"
alias pm="pulsemixer"
alias :q="exit"
alias clip="xclip -selection clipboard"
alias pl="paths list"
alias valgrind="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose"
alias btoff="bluetoothctl power off"
alias zzon="sudo wg-quick up Zauzoo-DHrabe"
alias zzoff="sudo wg-quick down Zauzoo-DHrabe"
alias sl="sl -ad -4"
alias f="fuck"
alias ce="code . && exit"
alias d="fvm dart"
alias fl="fvm flutter"

alias paru-r="paru -Rns"
complete -F _complete_alias paru-r

alias go="paths go"
complete -F _complete_alias go

alias config="git --git-dir=$HOME/.dots/ --work-tree=$HOME"
complete -F _complete_alias config

include ~/.bash_functions
include ~/.profile
