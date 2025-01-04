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
