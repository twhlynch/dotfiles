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
HISTSIZE=10000
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
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
  --color=hl:#f3be7c,hl+:#e0a363,info:#f3be7c,marker:#7e98e8
  --color=prompt:#bb9dbd,spinner:#7fa563,pointer:#aeaed1,header:#87afaf
  --color=border:#606079,scrollbar:#aeaed1,label:#aeaeae,query:#aeaed1
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="█" --separator="─" --scrollbar="▌"
  --layout="reverse"'

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'test -f {} && bat -n --color=always --paging=never -pp {} || tree -C {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --color=info:#d8647e
  --border-label='Files'"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'CTRL-Y to copy'
  --color=info:#7e98e8
  --border-label='History'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'
  --color=info:#7fa563
  --border-label='cd'"

# Aliases
alias ,a='abandon'
alias ,e='abandon-exit'
alias ,n='abandon-exit-notify'

function abandon() {
	eval $* & disown
}
function abandon-exit() {
	abandon $*
	exit
}
function notify() {
	$*
	terminal-notifier -title "Task complete" -message "$*" -sound Blow
}
function abandon-exit-notify() {
	abandon-exit notify $*
}

alias c='clear'
alias cl='clear'
alias cls='clear'

alias zr='unalias -a; source ~/.zshrc'

alias :q='exit'
alias :wq='exit'
alias :Q='exit'
alias q='exit'
alias qq='exit'

alias :w='echo dumbass'
alias lf:w='echo dumbass'

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

alias f='cd "$(find . -type d -maxdepth 1 -not -path "." | sed s/.\\/// | fzf)"'
alias fp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias hl='rg --passthru'

alias mkdir='mkdir -p'
alias cp='cp -r'

alias ka='killall'
alias k='kill -9'

alias neofetch='neofetch --ascii ~/.config/neofetch/ascii.txt'

function fetch() { # animated fetch, thanks pewds
	res=$(fastfetch -l " " --logo-type data-raw --pipe false --logo-padding-left 44)
	cols=$("$res" | wc -l)

	clear
	tput cup 1 1
	echo "$res"

	tput civis
	trap 'tput cnorm; stop=1; break;' INT TERM

	stop=0

	while true; do
		for frame in ~/.config/fastfetch/frames/*.txt; do
			tput cup 1 1
			ascii=$(cat "$frame")
			echo "$ascii"

			# Wait a little, but also check if user pressed a key
			read -t ${1:-0.05} -n 1 key && { tput cnorm; stop=1; break; }
		done
		[[ "$stop" -eq 1 ]] && break
	done
}

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
function ..() {
	local count=$1
	[[ -z $count ]] && count=1
	
	local cmd=""
	for (( i = 0; i < count; i++ )) do
		cmd+="../"
	done
	
	cd "${cmd[@]}"
}

alias path='echo -e ${PATH//:/\\n}'

alias pyvenv='python3 -m venv .venv'
alias pyserver='python3 -m http.server'

function py() {
	if command -v python &>/dev/null; then # try current venv
		python $@
	elif [[ -d "./.venv/" ]]; then # try activate .venv
		source ./.venv/bin/activate
		if command -v python &>/dev/null; then
			python $@
		else
			echo "Could not find python"
			return
		fi
	elif command -v python3 &>/dev/null; then # try python3
		python3 $@
	else
		echo "Could not find python"
	fi
}

function mk() {
	mkdir -p $1 && cd $1
}

alias lg='lazygit'

function crun() {
	version=$1
	shift
	name="${1%.*}"
	echo "g++ -std=c++$version -o \"$name\" $@ && ./$name"
	g++ -std=c++$version -o "$name" $@ && "./$name"
}

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

function dl() {
	local count=$1
	[[ -z $count ]] && count=1

	ls ~/Downloads -1 -s newest --absolute=on | tail -n $count | tr -d "'" |
	while IFS= read -r file; do
		echo "$file"
		cp "$file" .
	done
}

function prompt() {
	local input="$*"
	[[ -z $prompt ]] && prompt="ping!"
	echo "$input" | shortcuts run "prompt" | cat
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

function pid() {
	if [ $# -eq 0 ]; then
		echo "Usage: $0 <process_name>"
		return
	fi

	ps aux | grep "$1" | grep -v "grep" | awk -v this="$0" '{
		if ($12 != this) {
			print "\033[1;32mPID:\033[0m " $2, \
				"\033[1;31mCPU:\033[0m " $3, \
				"\033[1;35mMEM:\033[0m " $4, \
				"\033[1;36mTIME:\033[0m " $10, \
				"\033[1;34mPATH:\033[0m " $11, \
				$12, \
				$13
		}
	}'
}

function print_time() {
	local timezone=$1
	local label=$2
	local highlight=$3

	local RESET="\033[0m"

	echo -e "${highlight}$label${RESET} $(TZ=$timezone date +'%I:%M\033[90m%p %d %b')${RESET}"
}

function tz() {
	print_time "UTC-12" "NZST" ""
	print_time "UTC-11" "AEST" "\033[34m"
	print_time "UTC-10" "AEDT" "\033[34m"
	print_time "UTC-9" "JST " ""
	print_time "UTC-8" "CST " ""
	print_time "UTC-8" "SIN " ""
	print_time "UTC-5:30" "IST " ""
	print_time "UTC-4" "UAE " ""
	print_time "UTC-3" "MSK " ""
	print_time "UTC-1" "CET " "\033[34m"
	print_time "UTC" "UTC " "\033[35m"
	print_time "UTC+3" "BZ  " ""
	print_time "UTC+5" "EST " "\033[34m"
	print_time "UTC+6" "CST " ""
	print_time "UTC+7" "MST " ""
	print_time "UTC+8" "PST " ""
}

function decolor() {
	sed "s/\x1b\[[^m]*m//g"
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"


# BEGIN opam configuration
[[ ! -r '/Users/twhlynch/.opam/opam-init/init.zsh' ]] || source '/Users/twhlynch/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# auto open tmux in session or create session
[ "$TERM_PROGRAM" = "ghostty" ] && [[ $(tput lines) > 15 ]] && (tmux a > /dev/null 2>&1 || tmux > /dev/null 2>&1)