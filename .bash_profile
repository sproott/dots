#
# ~/.bash_profile
#

source ~/.bashrc

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.ghcup/bin" ] ; then
  PATH="$HOME/.ghcup/bin:$PATH"
fi
