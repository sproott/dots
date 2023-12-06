#!/usr/bin/env bash

connect() {
    bluetoothctl power on
    bluetoothctl connect $1
}

ds4() {
    connect 40:1B:5F:B4:AC:BF
}

jbl() {
    connect D8:37:3B:24:E7:42
}

sc() {
    connect E8:EE:CC:06:4D:82
}

title() {
  unset PROMPT_COMMAND
  if [[ -z $ORIG ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

launch() {
  "$@" >/dev/null 2>&1 &
  disown
}

mkcd() {
  mkdir -p "$1"
  cd "$1"
}

cwd() {
  pwd | tr -d '\n' | xclip -selection clipboard
}

pls() {
  sudo $(history 2 | head -1 | cut -f4- -d" ")
}

config_merges() {
  config checkout laptop && config pull && config merge master && config checkout master && config push --all
}

asm() {
  nasm -f elf32 -g -o "$1".o "$1".asm && gcc -m32 -o "$1" "$1".o
}

pydev() {
  echo "$1" | entr -cc "./$1"
}

freeport() {
  kill -9 $(lsof -ti:"$1")
}
