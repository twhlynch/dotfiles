
# install brew
if! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# fonts
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font

# essential installs
brew install git git-lfs ffmpeg docker coreutils
# config reqs
brew install neovim tmux zoxide fzf bat eza lazygit gh btop ripgrep oh-my-posh deno neofetch tldr thefuck fastfetch delta terminal-notifier
# dev stuff
brew install zig doxygen maven cargo stylua shfmt patchelf automake autoconf-archive ncurses git-filter-repo opam
# c/cpp
brew install cmake ninja clang-format gccclang-tidy
# other installs
brew install rlwrap

# python
brew install python@3.9 python@3.11 python@3.10 python@3.12 python@3.13

# latex
brew install texlive texlive-latex-extra ghostscript pdflatex basictex imagemagick
sudo tlmgr install amsmath amssymb amsfonts amscd mathtools preview standalone varwidth needspace mdframed lipsum

# apps
brew install --cask android-studio
brew install --cask visual-studio-code
brew install --cask temurin
brew install --cask wine-stable
brew install --cask ghostty
brew install --cask raycast

# node
brew install node npm pnpm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 16
nvm install 18
nvm install node

# xcode
xcode-select --install
sudo gem install xcpretty