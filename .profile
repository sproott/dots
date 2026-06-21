#!/usr/bin/env bash

# PATH additions for tools with env vars set in environment.d
export PATH="$PNPM_HOME/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/Android/Sdk/tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"

# pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init - bash)"

# Google Cloud SDK
[ -f /opt/google-cloud-cli/path.bash.inc ] && source /opt/google-cloud-cli/path.bash.inc

# Local overrides
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"

# Import systemd user environment (for non-systemd-aware shells)
set -o allexport
source <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
set +o allexport
