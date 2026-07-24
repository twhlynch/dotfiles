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

# editor
export EDITOR=nvim

# android dev
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NDK_HOME="$HOME/Library/Android/sdk/ndk/28.2.13676358"

# github cli
export GH_CONFIG_DIR="$HOME/.config/gh/personal"
