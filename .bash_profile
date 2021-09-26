#
# ~/.bash_profile
#

source ~/.bashrc

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin" ] ; then
  PATH="$GHCUP_INSTALL_BASE_PREFIX/.ghcup/bin:$PATH"
fi
