#!/bin/zsh

# functions from lewagon dots
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Backed up $target to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinked $link"
    ln -s $file $link
  fi
}

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
  for name in alacritty nvim ohmyposh ghostty neofetch lazygit bat; do
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
bat cache --build

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

# make custom bin if it doesn't exist
mkdir -p $HOME/bin

# symlink bin scripts
if [ -d "bin" ]; then
  for name in pid tz; do
    if [ ! -d "bin/$name" ]; then
      target="$HOME/bin/$name"
      backup $target
      symlink $PWD/bin/$name $target
    else
      echo "-----> $name not found"
    fi
  done
fi

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

# reload
exec zsh

echo "-----> dotfiles installed!"
