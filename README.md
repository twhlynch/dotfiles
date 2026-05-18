# MacOS dotfiles

Run `config.sh` to setup symlinks and macos defaults.

Run `installs.sh` to install brew and **many** packages and tools.

> NOTE: some config requires this repo is `~/dotfiles`.

### Main workflow

- MacOS
- Ghostty
- zsh
- Tmux
- Neovim
- LazyGit
- git

### Extras

- Arc browser userscripts
- Discord vencord settings

## Config

```sh
config
├── bat           # bat config (modern cat replacement)
├── fastfetch     # fastfetch config (neofetch alternative)
├── ghostty       # ghostty config (terminal)
├── git           # git config (you know what git is)
├── lazygit       # lazygit config (tui git client)
├── nvim          # neovim config (amazing IDE)
├── ohmyposh      # ohmyposh config (zsh bloat)
├── opencode      # opencode config (AI)
├── vscode        # vscode config (lame IDE)
├── xcode         # xcode theme
├── zsh           # zsh aliases and functions
├── LaunchAgents  # macos specific: remaps right option to F13
├── LaunchDaemons # macos specific: fixes 'Too many open files' from clangd on large codebases
├── Services      # macos specific: open with nvim quick action
├── .gitconfig    # git config
├── .hushlogin    # hide annoying macos tty message
├── .tmux.conf    # tmux config
├── .zprofile     # zsh profile file
└── .zshrc        # zsh config (bash alternative)
