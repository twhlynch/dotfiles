source "$HOME/dotfiles/config/zsh/theme.zsh"
source "$HOME/dotfiles/config/zsh/keys.zsh"
source "$HOME/dotfiles/config/zsh/history.zsh"
source "$HOME/dotfiles/config/zsh/functions.zsh"
source "$HOME/dotfiles/config/zsh/aliases.zsh"
source "$HOME/dotfiles/config/zsh/mac.zsh"
source "$HOME/dotfiles/config/zsh/auto.zsh"

if [[ "$(uname)" == "Darwin" ]]; then
	export PATH="$PATH:$(brew --prefix llvm)/bin"
	export PATH="$PATH:$(brew --prefix lldb)/bin"
fi

zsh-start-desktop() {
	[ -z "$DISPLAY" ] || [ "$TTY" = "$DESKTOP_TTY" ] || return
	read -r _
	start-hyprland
}
if [[ "$(uname)" == "Linux" ]]; then
	zsh-start-desktop
fi
