#!/bin/zsh

function backup() {
	target="$1"
	if [ -L "$target" ]; then
		rm -f "$target"
	elif [ -e "$target" ]; then
		mv "$target" "$target.backup"
		echo "-----> Backed up $target to $target.backup"
	fi
}

function symlink() {
	file="$1"
	link="$2"
	backup "$link"
	ln -s "$file" "$link"
	echo "-----> Symlinked $link"
}

# ensure .config exists
mkdir -p "$HOME/.config"

# symlink simple configs
if [ -d "config" ]; then
	for name in .hushlogin .zshrc .zprofile .tmux.conf .gitconfig alacritty nvim ohmyposh ghostty neofetch lazygit bat fastfetch; do
		if [ -d "config/$name" ]; then
			symlink "$PWD/config/$name" "$HOME/.config/$name"
		elif [ -f "config/$name" ]; then
			symlink "$PWD/config/$name" "$HOME/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure zed folder exists
mkdir -p "$HOME/.config/zed"

# symlink specific sub-files
if [ -d "config/zed" ]; then
	for name in zed/keymap.json zed/settings.json; do
		if [ -f "config/$name" ]; then
			symlink "$PWD/config/$name" "$HOME/.config/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure vscode folder exists
mkdir -p "$HOME/Library/Application Support/Code/User"

# symlink vscode config
if [ -d "config/vscode" ]; then
	for name in settings.json keybindings.json; do
		if [ -f "config/vscode/$name" ]; then
			symlink "$PWD/config/vscode/$name" "$HOME/Library/Application Support/Code/User/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure xcode config folder exists
mkdir -p "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"

# symlink xcode config
if [ -d "config/xcode" ]; then
	for name in FontAndColorThemes/Vague.xccolortheme; do
		if [ -f "config/xcode/$name" ]; then
			symlink "$PWD/config/xcode/$name" "$HOME/Library/Developer/Xcode/UserData/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure LaunchAgents folder exists
mkdir -p "$HOME/Library/LaunchAgents"

# symlink macos key remaps
if [ -d "config/LaunchAgents" ]; then
	for name in 'com.local.KeyRemapping.plist'; do
		if [ -f "config/LaunchAgents/$name" ]; then
			symlink "$PWD/config/LaunchAgents/$name" "$HOME/Library/LaunchAgents/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure Services folder exists
mkdir -p "$HOME/Library/Services"

# symlink macos automations
if [ -d "config/Services" ]; then
	for name in 'nvim.workflow'; do
		if [ -d "config/Services/$name" ]; then
			symlink "$PWD/config/Services/$name" "$HOME/Library/Services/$name"
		else
			echo "-----> $name not found"
		fi
	done
fi

# ensure bin folder exist (useful for placing random bins into)
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

echo "-----> Setup macos defaults"

# reload Dock
killall Dock

# reload bat theme
bat cache --build > /dev/null

# reload ghostty
osascript "$HOME/.config/ghostty/reload_ghostty_config.scpt" &>/dev/null

# reload zsh
unalias -a; source ~/.zshrc

echo "-----> dotfiles installed!"