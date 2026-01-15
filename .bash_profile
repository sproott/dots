#!/usr/bin/env bash

source "$HOME"/.bashrc

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.ghcup/bin:$PATH"
PATH="$HOME/.pub-cache/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.local/share/coursier/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[ -f /home/davidh/.dart-cli-completion/bash-config.bash ] && . /home/davidh/.dart-cli-completion/bash-config.bash || true
## [/Completion]

###-begin-nr-completion-###

if type complete &>/dev/null; then
  _nr_completion() {
    local words
    local cur
    local cword
    _get_comp_words_by_ref -n =: cur words cword
    IFS=$'\n'
    COMPREPLY=($(COMP_CWORD=$cword COMP_LINE=$cur nr --completion ${words[@]}))
  }
  complete -F _nr_completion nr
fi

###-end-nr-completion-###
