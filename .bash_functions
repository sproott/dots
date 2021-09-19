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

marshall() {
    connect 2C:4D:79:C4:9C:F4
}

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
  mkdir "$1"
  cd "$1"
}

