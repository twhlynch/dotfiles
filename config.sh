#!/bin/zsh

set -euo pipefail

function label() {
	echo "---> $@"
}

function backup() {
	target="$1"

	if [ -L "$target" ]; then
		rm -f "$target"
	elif [ -e "$target" ]; then
		mv "$target" "$target.backup"
		label "Backed up $target to $target.backup"
	fi
}

function symlink() {
	file="$PWD/$1"
	link="$2"

	if [ ! -e "$file" ]; then
		label "$file not found"
	else
		mkdir -p "$(dirname "$link")"
		backup "$link"
		ln -s "$file" "$link"
		label "Symlinked $link"
	fi
}

# ~ configs
for name in .hushlogin .zshrc .zprofile .tmux.conf .gitconfig; do
	symlink "config/$name" "$HOME/$name"
done

# ~/.config configs

for name in nvim ohmyposh ghostty lazygit bat fastfetch git opencode/themes opencode/AGENTS.md; do
	symlink "config/$name" "$HOME/.config/$name"
done

# alternate location configs

# vscode
for name in settings.json keybindings.json; do
	symlink "config/vscode/$name" "$HOME/Library/Application Support/Code/User/$name"
done

# xcode
for name in FontAndColorThemes/Vague.xccolortheme; do
	symlink "config/macos/xcode/$name" "$HOME/Library/Developer/Xcode/UserData/$name"
done

# macos key remaps
for name in com.local.KeyRemapping.plist; do
	symlink "config/macos/LaunchAgents/$name" "$HOME/Library/LaunchAgents/$name"
done

# macos file limit override
for name in limit.maxfiles.plist; do
	symlink "config/macos/LaunchDaemons/$name" "/Library/LaunchDaemons/$name"
done

# macos automations
for name in nvim.workflow nvim.app; do
	symlink "config/macos/Services/$name" "$HOME/Library/Services/$name"
done

# other

# ensure ~/bin exist (dir for arbitrary bins)
mkdir -p "$HOME/bin"

# apple defaults

# Dock
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock show-process-indicators -int 1
defaults write com.apple.dock show-recents -int 0
defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock magnification -int 0
# WindowManager
defaults write com.apple.WindowManager EnableTiledWindowMargins -int 0
# arc browser icon
defaults write company.thebrowser.Browser currentAppIconName hologram

label "Setup macos defaults"

# reloading

# reload macos
killall Dock
killall WindowManager

# reload bat theme
bat cache --build > /dev/null

# reload ghostty
osascript "$HOME/.config/ghostty/reload_ghostty_config.scpt" &>/dev/null

# reload zsh
set +u
unalias -a; source ~/.zshrc

label "config complete!"
