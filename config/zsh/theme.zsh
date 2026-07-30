#
# theme and completion
#

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# oh-my-posh initialization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# completions
autoload -Uz compinit && compinit

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

# man page colors
export LESS_TERMCAP_md=$(tput bold; tput setaf 4) # begin bold
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1) # begin bold blinking
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 6) # begin underline
export LESS_TERMCAP_so=$(tput bold; tput setab 3; tput setaf 8) # start standout (search)
export LESS_TERMCAP_me=$(tput sgr0) # end special
export LESS_TERMCAP_se=$(tput sgr0) # end standout
export LESS_TERMCAP_ue=$(tput sgr0) # end underline
export LESS_TERMCAP_mr=$(tput rev) # begin reverse
export LESS_TERMCAP_mh=$(tput dim) # begin dim
export MANPAGER='less'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# cache dump something?
zinit cdreplay -q
