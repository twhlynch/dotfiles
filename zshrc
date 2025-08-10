if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# oh-my-posh initialization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# Keybindings
bindkey -v # vi mode
bindkey -ar ":" # remove command mode
export KEYTIMEOUT=1 # Remove timeout for <Esc>
bindkey -v '^?' backward-delete-char # Fix backspace
# Alt+Backspace delete word
bindkey -M viins '\e\x7F' backward-kill-word
bindkey -M vicmd '\e\x7F' backward-kill-word
# Alt+Left/Right to jump words in insert mode
bindkey -M viins '^[b' backward-word
bindkey -M viins '^[f' forward-word
bindkey -M vicmd '^[b' backward-word
bindkey -M vicmd '^[f' forward-word
# Cmd+Left/Right to jump to start or end of line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -s -M vicmd '^A' '^'
bindkey -s -M vicmd '^E' '$'
# use bar cursor for insert mode, block cursor for normal mode
_bar_cursor() { echo -ne "\e[5 q" }
_block_cursor() { echo -ne "\e[1 q" }
zle-keymap-select() {
	if [ "$KEYMAP" = "vicmd" ]
		then _block_cursor
		else _bar_cursor
	fi
}
zle -N zle-keymap-select
_bar_cursor # bar cursor on startup
precmd_functions+=(_bar_cursor) # bar cursor on new prompt

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

# fzf style
export FZF_DEFAULT_OPTS="
	--height=99%
	--layout=reverse
	--pointer='█'
	--scrollbar='▌'
	--highlight-line
	--color=hl:#f3be7c
	--color=bg:-1
	--color=gutter:-1
	--color=bg+:#252530
	--color=fg+:#aeaed1
	--color=hl+:#f3be7c
	--color=border:#606079
	--color=prompt:#bb9dbd
	--color=query:#aeaed1:bold
	--color=pointer:#aeaed1
	--color=scrollbar:#aeaed1
	--color=info:#f3be7c
	--color=spinner:#7fa563
	"

# Aliases
alias ,='abandon'
alias ,,='abandon-exit'

function abandon() {
	eval $* & disown
}
function abandon-exit() {
	abandon $*
	exit
}

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
alias ta='tmux a'

alias .z='cd ~ && nvim .zshrc'
alias .c='cd ~/.config && nvim .'
alias .d='cd ~/dotfiles && nvim .'
alias .v='cd ~/dotfiles/config/nvim && nvim .'

alias v='nvim'

alias ls='eza --group-directories-first'
alias l='ls'
alias la='ls -la'
alias tree='ls --tree --git-ignore'

alias cat='bat --paging=never -pp'

alias f='fzf'
alias fp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias hl='rg --passthru'

alias mkdir='mkdir -p'
alias cp='cp -r'

alias ka='killall'
alias k='kill -9'

alias neofetch='neofetch --ascii ~/.config/neofetch/ascii.txt'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
function ..n() {
	for (( i = 0; i < $1; i++ )) do
		cd ..
	done
}

alias path='echo -e ${PATH//:/\\n}'

alias pyvenv='python3 -m venv .venv'
alias pyserver='python3 -m http.server'

function mk() {
	mkdir -p $1 && cd $1
}

alias lg='lazygit'

# from dxrcy
# github util
GH='https://github.com'
GH_MAIN='twhlynch'
GHU="$GH/$GH_MAIN"

alias gcl='git-clone-cd'
alias ghu='gh-url'
function gh-url() {
	url="$1"
	case "$url" in
		'') return 1 ;;
		@*) echo "$GH/${url:1}" ;;
		:*) echo "$GHU/${url:1}" ;;
		 *) echo "$url" ;;
	esac
}
function git-clone-cd() {
	url="$(gh-url $1)" || { git clone ; return $?; }
	shift
	git clone "$url" $* || return $?
	target="$1"
	if [ -z "$target" ]; then
		target="$(echo "$url" \
			| sed 's|/$||' \
			| sed 's|\.git$||' \
			| sed 's|^.*/||'\
		)"
	fi
	cd "./$target"
}

function commit() {
	git add .
	git commit -m "$*"
	git push
}

# lazy load slow af nvm
function nvm() {
	export NVM_DIR="$HOME/.nvm"

	if ! command -v nvm_ls >/dev/null 2>&1; then
		echo "Loading nvm"
		source "$NVM_DIR/nvm.sh"  # This loads nvm
		source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

		nvm
	else
		command nvm "$@"
	fi
}

function mvn-init() {
	if [[ -z $1 ]]; then
		echo "mvn-init projectName"
		return
	fi

	mvn archetype:generate \
		-DgroupId=com.twhlynch.$1 \
		-DartifactId=$1 \
		-DarchetypeArtifactId=maven-archetype-quickstart \
		-DinteractiveMode=false
}

function compile-commands() {
	if [[ -z $1 ]]; then
		echo "compile-commands path/to/PROJECT.xcodeproj build"
		return
	fi

	xcodebuild -project $1 | \
	xcpretty -r json-compilation-database --output $2/compile_commands.json
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"


# BEGIN opam configuration
[[ ! -r '/Users/twhlynch/.opam/opam-init/init.zsh' ]] || source '/Users/twhlynch/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# auto open tmux in session or create session
tmux a > /dev/null 2>&1 && tmux > /dev/null 2>&1
