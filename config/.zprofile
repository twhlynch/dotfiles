# homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# update path
PATH="${HOME}/bin:${PATH}"
PATH="${HOME}/.local/bin:${PATH}"
PATH="/Applications/CMake.app/Contents/bin:${PATH}"
PATH="/Applications/Blender.app/Contents/MacOS:${PATH}"
PATH="${HOME}/Library/Android/sdk/platform-tools:${PATH}"
PATH="${HOME}/go/bin:${PATH}"

export PATH

# config
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# editor
export EDITOR=nvim

# android dev
export ANDROID_HOME="$HOME/Library/Android/sdk"
if [[ -d "$ANDROID_HOME/ndk" ]]; then
	export NDK_HOME="$ANDROID_HOME/ndk/$(ls "$ANDROID_HOME/ndk" | sort -V | tail -n 1)"
fi

# github cli
export GH_CONFIG_DIR="$HOME/.config/gh/personal"
export GH_USER="twhlynch"
export GH_USER_ALT="twhlynch-rmit"

if [[ -f "$HOME/dotfiles/config/.env" ]]; then
	set -a && source "$HOME/dotfiles/config/.env" && set +a
fi
