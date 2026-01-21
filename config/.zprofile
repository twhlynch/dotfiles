# homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# update path
PATH="${HOME}/Library/Python/3.12/bin:${PATH}"
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
PATH="${HOME}/bin:${PATH}"
PATH="/Applications/CMake.app/Contents/bin:${PATH}"
PATH="${HOME}/Library/Android/sdk/platform-tools:${PATH}"
PATH="${HOME}/go/bin:${PATH}"
PATH="/Applications/Blender.app/Contents/MacOS:${PATH}"

export PATH

# config
export XDG_CONFIG_HOME="$HOME/.config"

# editor
export EDITOR=nvim
