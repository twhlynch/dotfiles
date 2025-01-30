
# install brew
if! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew tap homebrew/cask-fonts

# brew installs
brew install git
brew install git-lfs
brew install zoxide
brew install fzf
brew install tmux
brew install bat
brew install eza
brew install tldr
brew install thefuck
brew install neovim
brew install neofetch
brew install lazygit
brew install gh
brew install ninja
brew install btop
brew install clang-format
brew install zig
brew install python@3.12
brew install php
brew install vlc
brew install --cask oh-my-posh
brew install --cask android-studio
brew install --cask visual-studio-code
brew install --cask ngrok
brew install --cask temurin
brew install --cask wine-stable
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font
brew install --cask ghostty
brew install --cask raycast

# node
brew install node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 16
nvm install 18
nvm install node

# xcode
xcode-select --install