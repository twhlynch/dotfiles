# install brew
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! xcode-select -p &>/dev/null; then
	xcode-select --install
fi

# git
brew install git git-delta git-filter-repo git-lfs gh
# libraries & build tools
brew install zlib glib openssl@3 autoconf autoconf-archive patchelf pkgconf automake ccache libraw libtool ncurses
brew install cmake ninja gcc make doxygen harfbuzz lld llvm xcode-build-server docker
sudo gem install xcpretty
# cli utils
brew install coreutils grep jq ripgrep ffmpeg tree unzip
brew install zoxide tmux bat eza fzf btop lazygit neovim fastfetch
brew install apktool rlwrap terminal-notifier oh-my-posh thefuck tldr yt-dlp cloc
# languages
brew install python@3.8 python@3.9 python@3.10 python@3.11 python@3.12 python@3.13 python-tk@3.9 python-tk@3.13 pipx
brew install lua zig go php nasm cargo
brew install clang-format shfmt stylua clang-tidy
# node
brew install node npm pnpm deno
# jvm
brew install openjdk maven
brew install --cask temurin
# fonts
brew install --cask font-hack-nerd-font font-jetbrains-mono-nerd-font font-meslo-lg-nerd-font
# latex
brew install --cask basictex
brew install texlive texlive-latex-extra ghostscript pdflatex imagemagick
sudo tlmgr install amsmath amssymb amsfonts amscd mathtools preview standalone varwidth needspace mdframed lipsum
# wine
brew install --cask wine-stable
brew install winetricks
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 16
nvm install 18
nvm install 22
nvm install 25
# apps
brew install --cask ngrok raycast stats ghostty vlc visual-studio-code android-studio
