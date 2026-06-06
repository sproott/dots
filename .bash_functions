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
  kill -9 $(lsof -tiTCP:"$1" -sTCP:LISTEN)
}

dotnetClearCommon() {
    echo "- remove .paket"
    rm -rf .paket

    echo "- remove bin"
    rm -rf bin/
    rm -rf build/bin/
    rm -rf src/bin/
    rm -rf tests/bin/

    echo "- remove obj"
    rm -rf obj/
    rm -rf build/obj/
    rm -rf src/obj/
    rm -rf tests/obj/

    echo "- remove .fake"
    rm -rf .fake

    echo "- remove .ionide"
    rm -rf .ionide

    echo "- remove packages"
    rm -rf packages

    echo "- remove paket-files"
    rm -rf paket-files

    echo "done"
}

chocen() {
  xrandr --output HDMI-A-0 --mode 1680x1050 --right-of eDP
  wallpaper nord > /dev/null
}

brno() {
  xrandr --output HDMI-A-0 --mode 1920x1080 --right-of eDP
  wallpaper nord > /dev/null
}
