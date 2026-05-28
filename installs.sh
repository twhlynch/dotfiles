#!/usr/bin/env bash
set -euo pipefail

# MARK: xcode

if ! xcode-select -p &>/dev/null; then
	xcode-select --install
fi

# MARK: homebrew

if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
brew update

# MARK: git

brew install git git-lfs \
	git-delta git-filter-repo gh

# MARK: build tools

brew install \
	make cmake ninja \
	autoconf autoconf-archive automake pkgconf \
	ccache libraw libtool patchelf \
	harfbuzz \
	lld llvm gcc \
	glib \
	doxygen \
	ncurses \
	openssl@3 \
	zlib

brew install xcpretty xcode-build-server bear docker

# MARK: CLI tools

brew install \
	neovim tmux fzf lazygit yazi \
	coreutils \
	bat eza grep ripgrep jq btop zoxide \
	fastfetch \
	opencode \
	unzip sevenzip \
	fd poppler resvg \
	cloc \
	yt-dlp \
	thefuck \
	tldr \
	exiftool \
	cowsay \
	libqalculate \
	parallel \
	apktool \
	oh-my-posh \
	rlwrap \
	terminal-notifier

brew install ffmpeg-full imagemagick-full
brew link ffmpeg-full imagemagick-full -f --overwrite

# MARK: languages & toolchains

brew install \
	lua luarocks \
	openjdk maven \
	rust \
	zig \
	go \
	php \
	nasm \
	opam \
	clingo \
	swi-prolog

brew install \
	pipx \
	python@3.8 python@3.9 python@3.10 python@3.11 python@3.12 python@3.13 python-tk@3.14

brew install \
	clang-format \
	clang-tidy \
	shfmt \
	stylua \
	tinymist \
	asp-lsp \
	tauri-cli

brew install --cask temurin

# MARK: node

brew install npm pnpm deno

if [ ! -d "$HOME/.nvm" ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

nvm install --lts
nvm install 22
nvm install 18
nvm install 25

npm install -g wrangler
npm install -g vsce
npm install -g ovsx

# MARK: fonts

brew install --cask \
	font-hack-nerd-font \
	font-jetbrains-mono-nerd-font \
	font-meslo-lg-nerd-font \
	font-symbols-only-nerd-font

# MARK: LaTeX

brew install typst

brew install texlive texlive-latex-extra ghostscript
brew install --cask basictex

sudo tlmgr update --self

sudo tlmgr install \
	amsfonts amscd amsmath amssymb \
	mathtools mdframed needspace preview standalone varwidth lipsum

# MARK: Wine

brew install --cask wine-stable
brew install winetricks

# MARK: cargo

cargo install --locked tree-sitter-cli

# MARK: apps

brew install --cask \
	ghostty \
	raycast \
	android-studio \
	stats \
	visual-studio-code \
	vlc

# MARK: cleanup

brew cleanup
echo "Installed"
