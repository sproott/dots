#
# ~/.bash_profile
#

include() {
  test -f "$1" && source "$@"
}

include ~/.bashrc

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.ghcup/bin" ] ; then
  PATH="$HOME/.ghcup/bin:$PATH"
fi

include ~/.profile
