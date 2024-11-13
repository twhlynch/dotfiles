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
  fi
done

# symlink .config folders
if [ -d "config" ]; then
  for name in alacritty nvim ohmyposh; do
    if [ -d "config/$name" ]; then
      target="$HOME/.config/$name"
      backup $target
      symlink $PWD/config/$name $target
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
    fi
  done
fi

# make custom bin if it doesn't exist
mkdir -p $HOME/bin

# symlink bin scripts
if [ -d "bin" ]; then
  for name in pid; do
    if [ ! -d "bin/$name" ]; then
      target="$HOME/bin/$name"
      backup $target
      symlink $PWD/bin/$name $target
    fi
  done
fi

# reload
exec zsh

echo "-----> dotfiles installed!"
