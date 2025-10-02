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

# autocd
setopt AUTOCD

# completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# oh-my-posh initialization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

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

# preexec() {
# 	[[ -n $__PREEXEC_RUNNING ]] && return
# 	__PREEXEC_RUNNING=1
# 	if ! preexec_implicit_grep $1; then
# 		unset __PREEXEC_RUNNING
# 		kill -INT $$
# 	fi
# 	unset __PREEXEC_RUNNING
# }
#
# preexec_implicit_grep() {
# 	case $1 in
# 		*\|\ *\"*\"*) ;;
# 		*) return 0 ;;
# 	esac
#
# 	eval $(echo "$1" | sed 's/| "\([^"]*\)"/| grep "\1"/g')
# 	return 1
# }

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
function configure-fzf() {
	local fzf_default_opts=(
		--color '"fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626"'
		--color '"hl:#f3be7c,hl+:#e0a363,info:#f3be7c,marker:#7e98e8"'
		--color '"prompt:#bb9dbd,spinner:#7fa563,pointer:#aeaed1,header:#87afaf"'
		--color '"border:#606079,scrollbar:#aeaed1,label:#aeaeae,query:#aeaed1"'
		--border '"rounded"'
		--border-label '""'
		--preview-window '"border-rounded"'
		--prompt '"> "'
		--marker '">"'
		--pointer '"█"'
		--separator '"─"'
		--scrollbar '"▌"'
		--layout '"reverse"'
	)
	local fzf_ctrl_t_opts=(
		--walker-skip '".git,node_modules,target"'
		--preview '"test -f {} && bat -n --color=always --paging=never -pp {} || tree -C {}"'
		--bind '"ctrl-/:change-preview-window(down|hidden|)"'
		--color '"info:#d8647e"'
		--border-label '"Files"'
	)
	local fzf_ctrl_r_opts=(
		--bind '"ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"'
		--color '"header:italic"'
		--header '"CTRL-Y to copy"'
		--color '"info:#7e98e8"'
		--border-label '"History"'
	)
	local fzf_alt_c_opts=(
		--walker-skip '".git,node_modules,target"'
		--preview '"tree -C {}"'
		--color '"info:#7fa563"'
		--border-label '"cd"'
	)

	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS ${fzf_default_opts[@]}"
	export FZF_CTRL_T_OPTS="${fzf_ctrl_t_opts[@]}"
	export FZF_CTRL_R_OPTS="${fzf_ctrl_r_opts[@]}"
	export FZF_ALT_C_OPTS="${fzf_alt_c_opts[@]}"
}
configure-fzf

source "$HOME/dotfiles/config/zsh/functions.zsh"
source "$HOME/dotfiles/config/zsh/aliases.zsh"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"

# BEGIN opam configuration
[[ ! -r '/Users/twhlynch/.opam/opam-init/init.zsh' ]] || source '/Users/twhlynch/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# auto open tmux in session or create session
[ "$TERM_PROGRAM" = "ghostty" ] && [[ $(tput lines) > 15 ]] && (tmux a > /dev/null 2>&1 || tmux > /dev/null 2>&1)