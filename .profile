#!/usr/bin/env bash

# Sourced by both the bash login shell and SDDM's Xsession; nested shells inherit the result.
[ -n "$__PROFILE_SOURCED" ] && return
export __PROFILE_SOURCED=1

# Import systemd user environment (for non-systemd-aware shells)
set -o allexport
source <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
set +o allexport

# PATH additions for tools with env vars set in environment.d
export PATH="$PNPM_HOME/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/Android/Sdk/tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"

# pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Google Cloud SDK
[ -f /opt/google-cloud-cli/path.bash.inc ] && source /opt/google-cloud-cli/path.bash.inc

# Local overrides
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/coursier/bin:$PATH"
