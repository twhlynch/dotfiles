
# runs after cd
chpwd() {
	# python
	if [[ -d .venv ]]; then
		source .venv/bin/activate
	fi

	# nvm
	if [[ -f .nvmrc ]]; then
		nvm use
	fi

	# node
	if [[ -n "$PROJECT_NODE_BIN" ]]; then
		path=("${(@)path:#${(b)PROJECT_NODE_BIN}}")
	fi
	export PROJECT_NODE_BIN=""

	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		if [[ -d "$dir/node_modules/.bin" ]]; then
			export PROJECT_NODE_BIN="$dir/node_modules/.bin"
			path=("$PROJECT_NODE_BIN" $path)
			break
		fi
		dir="${dir:h}"
	done

	# java
	if [[ -f .java-version ]]; then
		export JAVA_HOME="$(/usr/libexec/java_home -v "$(cat .java-version | tr -d '\n')")"
		echo "Using $JAVA_HOME"
	fi

	# gh
	if [[ $OSTYPE == darwin* ]]; then
		if is_in_uni_dir; then
			export GH_CONFIG_DIR="$HOME/.config/gh/rmit"
			export GH_TOKEN=$(gh auth token --user "$GH_USER_ALT")
		else
			export GH_CONFIG_DIR="$HOME/.config/gh/personal"
			export GH_TOKEN=$(gh auth token --user "$GH_USER")
		fi
	fi
}

# auto open tmux in session or create session
[ "$TERM_PROGRAM" = "ghostty" ] && (tmux a > /dev/null 2>&1 || tmux > /dev/null 2>&1)

# cd hooks on tmux window creation
if [ -n "$TMUX" ]; then
	chpwd
fi
