# run in background
alias ,a='abandon'
alias ,e='abandon-exit'
alias ,n='abandon-exit notify'

# clear
alias c='clear'
alias cl='clear'
alias cls='clear'

# reload config
alias zr='unalias -a; source ~/.zshrc'

# exit
alias :q='exit'
alias :wq='exit'
alias :Q='exit'
alias q='exit'
alias qq='exit'

# funny
alias :w='echo dumbass'
alias lf:w='echo dumbass'

# tmux
alias t='tmux'
alias tx='tmux'
alias ta='tmux a'

# quick dotfiles
alias .d='cd ~/dotfiles && nvim .'

# nvim
alias v='nvim'
alias v.='nvim .'

# ls
alias ls='eza --group-directories-first'
alias l='ls'
alias la='ls -la'
alias tree='ls --tree --git-ignore'

# cat
alias cat='bat --paging=never -pp'

# fzf
alias f='cd "$(find . -type d -maxdepth 1 -not -path "." | sed s/.\\/// | fzf)"'
alias fp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias hl='rg --passthru'

# annoying
alias mkdir='mkdir -p'
alias cp='cp -r'

# kill
alias ka='killall'
alias k='kill -9'

# custom neofetch ascii
alias neofetch='neofetch --ascii ~/.config/neofetch/ascii.txt'

# cd
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'

# path
alias path='echo -e ${PATH//:/\\n}'

# python
alias pyvenv='python3 -m venv .venv'
alias pyserver='python3 -m http.server'

# lazygit
alias lg='lazygit'

# git clone
alias gcl='git-clone-cd'
alias ghu='gh-url'

# nice
alias \$=""
