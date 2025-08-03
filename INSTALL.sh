
# install brew
if! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font

# brew installs
brew install ffmpeg git git-lfs neovim tmux zoxide fzf bat eza lazygit gh ninja btop clang-format zig python3 oh-my-posh ripgrep deno doxygen docker pnpm maven cargo stylua shfmt patchelf automake autoconf-archive gcc ncurses clang-tidy git-filter-repo neofetch tldr thefuck

brew install texlive texlive-latex-extra ghostscript pdflatex basictex imagemagick
sudo tlmgr install amsmath amssymb amsfonts amscd mathtools preview standalone varwidth needspace mdframed lipsum

brew install --cask android-studio
brew install --cask visual-studio-code
brew install --cask temurin
brew install --cask wine-stable

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
sudo gem install xcpretty
