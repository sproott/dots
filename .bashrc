#
# ~/.bashrc
#

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
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export VISUAL="nvim"
export EDITOR="$VISUAL"

alias vim="nvim"
alias config="git --git-dir=$HOME/.dots/ --work-tree=$HOME"
alias ls="exa --long --color=auto"
alias pm="pulsemixer"

[[ -f ~/.bash_functions ]] && . ~/.bash_functions
