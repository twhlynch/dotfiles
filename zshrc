if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

export PATH="$HOME/bin:$PATH"

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux

# completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# oh-my-posh initialization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# Aliases
alias c='clear'
alias cl='clear'
alias cls='clear'

alias :q='exit'
alias :wq='exit'
alias :Q='exit'
alias q='exit'
alias qq='exit'

alias t='tmux'
alias tx='tmux'

alias .z='cd ~ && nvim .zshrc'
alias .c='cd ~ && nvim .config'
alias .d='cd ~ && nvim dotfiles'
alias dots='cd ~/dotfiles && code .'

alias ls='eza --group-directories-first'
alias la='ls -la'
alias lst='ls -T'
alias tree='ls -T'

alias cat='bat --paging=never -pp'

alias f='fzf'
alias fp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

alias mkdir='mkdir -p'

alias ka='killall'
alias k='kill -9'

alias neofetch='neofetch --ascii ~/.config/neofetch/ascii.txt'

alias ..='cd ..'

alias path='echo -e ${PATH//:/\\n}'

function commit() {
    git add . 
    git commit -m "$*"
    git push
}

function pyvenv() {
    if [ ! -d "bin" ]; then
        python3 -m venv .
    fi
    if [ ! -f "requirements.txt" ]; then
        bin/pip freeze > requirements.txt
    fi
    bin/pip install -r requirements.txt
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"
