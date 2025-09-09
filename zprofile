# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# update path
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
PATH="${HOME}/bin:${PATH}"
PATH="/Applications/CMake.app/Contents/bin:${PATH}"

export PATH

# config
export XDG_CONFIG_HOME="$HOME/.config"

# editor
export EDITOR=nvim