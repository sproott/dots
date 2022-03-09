#!/usr/bin/env bash

title() {
  unset PROMPT_COMMAND
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

launch() {
  "$@" > /dev/null 2>&1 & disown
}

mkcd() {
  mkdir -p "$1"
  cd "$1"
}

cwd() { 
  pwd | tr -d '\n' | xclip -selection clipboard 
}

wcyd() {
  echo 'What can you do.' 
  $(mpv ~/Data/Audio/wcyd.wav &>/dev/null & disown)
}

pls() {
  sudo $(history 2 | head -1 | cut -f4- -d" ")
}

config_merges() {
  config checkout work && config pull && config merge master && config checkout laptop && config pull && config merge master && config push --all
}
