
# runs after cd
chpwd() {
	if [[ -d .venv ]]; then
		source .venv/bin/activate
	fi

	if [[ -f .nvmrc ]]; then
		nvm use
	fi

	if [[  $OSTYPE == darwin* && "$PWD" == "$HOME/Documents/RMIT/gitdir"/* ]]; then
		gh-uni
	fi
}

# auto open tmux in session or create session
[ "$TERM_PROGRAM" = "ghostty" ] && (tmux a > /dev/null 2>&1 || tmux > /dev/null 2>&1)

# cd hooks on tmux window creation
if [ -n "$TMUX" ]; then
	chpwd
fi
