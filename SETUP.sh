#!/bin/zsh

function backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Backed up $target to $target.backup"
    fi
  fi
}

function symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinked $link"
    ln -s $file $link
  fi
}

# ensure .config exists
mkdir -p $HOME/.config

# symlink main config files from $name to ~/.$name
for name in zshrc zprofile tmux.conf gitconfig; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/$name $target
  else
    echo "-----> $name not found"
  fi
done

# symlink .config folders
if [ -d "config" ]; then
  for name in alacritty nvim ohmyposh ghostty neofetch lazygit bat fastfetch; do
    if [ -d "config/$name" ]; then
      target="$HOME/.config/$name"
      backup $target
      symlink $PWD/config/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# update bat theme
bat cache --build > /dev/null
echo "-----> Rebuilt bat cache"

# ensure folders exist
mkdir -p $HOME/.config/zed

# symlink specific .config files
if [ -d "config" ]; then
  for name in zed/keymap.json zed/settings.json; do
    if [ ! -d "config/$name" ]; then
      target="$HOME/.config/$name"
      backup $target
      symlink $PWD/config/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# ensure vscode config folder exists
mkdir -p $HOME/Library/Application\ Support/Code/User

# symlink vscode config
if [ -d "vscode" ]; then
  for name in settings.json keybindings.json; do
    if [ ! -d "vscode/$name" ]; then
      target="$HOME/Library/Application Support/Code/User/$name"
      backup $target
      symlink $PWD/vscode/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# ensure xcode config folder exists
mkdir -p $HOME/Library/Developer/Xcode/UserData
mkdir -p $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes

# symlink xcode config
if [ -d "xcode" ]; then
  for name in FontAndColorThemes/Vague.xccolortheme; do
    if [ ! -d "xcode/$name" ]; then
      target="$HOME/Library/Developer/Xcode/UserData/$name"
      backup $target
      symlink $PWD/xcode/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# ensure LaunchAgents folder exists
mkdir -p $HOME/Library/LaunchAgents
# symlink macos key remaps
if [ -d "LaunchAgents" ]; then
  for name in 'com.local.KeyRemapping.plist'; do
    if [ ! -d "LaunchAgents/$name" ]; then
      target="$HOME/Library/LaunchAgents/$name"
      backup $target
      symlink $PWD/LaunchAgents/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# ensure Services folder exists
mkdir -p $HOME/Library/Services
# symlink macos automations
if [ -d "Services" ]; then
  for name in 'nvim.workflow'; do
    if [ -d "Services/$name" ]; then
      target="$HOME/Library/Services/$name"
      backup $target
      symlink $PWD/Services/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

# ensure bin folder exist (useful for placing random bins into)
mkdir -p $HOME/bin

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

killall Dock

echo "-----> Setup macos defaults"

# reload
exec zsh

echo "-----> dotfiles installed!"