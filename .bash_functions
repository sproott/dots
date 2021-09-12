function title() {
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

