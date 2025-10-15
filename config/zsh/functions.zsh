# run in background
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

# animated fetch, thanks pewds
function fetch() {
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

# cd .. * n
function ..() {
	local count=$1
	[[ -z $count ]] && count=1

	local cmd=""
	for (( i = 0; i < count; i++ )) do
		cmd+="../"
	done

	cd "${cmd[@]}"
}

# python
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

# mkdir and cd
function mk() {
	mkdir -p $1 && cd $1
}

# build and run c/cpp
function crun() {
	version=$1
	shift
	name="${1%.*}"
	echo "g++ -std=c++$version -o \"$name\" $@ && ./$name"
	g++ -std=c++$version -o "$name" $@ && "./$name"
}

# reload all
function super-reload() {
	# reload ghostty config
	osascript "$HOME/.config/ghostty/reload_ghostty_config.scpt" &>/dev/null
	# reload tmux config
	tmux source-file ~/.tmux.conf
	# reload zsh config
	unalias -a; source ~/.zshrc
}

# github
GH='https://github.com'
GH_MAIN='twhlynch'
GHU="$GH/$GH_MAIN"

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
function gh-create() {
	if [ ! -d ".git" ]; then
		git init
		git add .
		git commit -m "Initial Commit"
	fi

	name="$1"
	[[ -z $name ]] && name=$(basename "$PWD")

	gh repo create "$name" --private --source=. --remote=upstream

	git push --set-upstream upstream HEAD:main
}
function commit() {
	git add .
	git commit -m "$*"
	git push
}

# copy recent downloads
function dl() {
	local count=$1
	[[ -z $count ]] && count=1

	eza ~/Downloads -1 -s newest --absolute=on | tail -n $count | tr -d "'" |
	while IFS= read -r file; do
		echo "$file"
		cp "$file" .
	done
}

# apple ai sucks lol
function prompt() {
	local input="$*"
	[[ -z $input ]] && input="ping!"
	echo "$input" | shortcuts run "prompt" | cat
}

# adjust ghostty blur
function blur() {
	config_file="$HOME/.config/ghostty/config"

	[[ ! -f "$config_file" ]] && exit 1

	current_blur="$(grep "^background-blur-radius = \d*$" "$config_file" | sed "s/background-blur-radius = //")"
	default_blur="$(grep "^# background-blur-radius = \d*$" "$config_file" | sed "s/# background-blur-radius = //")"
	[[ -z "$current_blur" ]] && exit 1
	[[ -z "$default_blur" ]] && exit 1

	new_blur="$1"
	if [ -z "$new_blur" ]; then
		if [ "$current_blur" -eq "$default_blur" ]; then
			new_blur="0"
		else
			new_blur="$default_blur"
		fi
	fi

	sed -i "" "s/^background-blur-radius = [0-9]*\$/background-blur-radius = $new_blur/" "$config_file"

	echo "blur: $current_blur -> $new_blur"

	osascript "$HOME/.config/ghostty/reload_ghostty_config.scpt" &>/dev/null
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

# setup java project
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

# java home
function java-use() {
	export JAVA_HOME=`/usr/libexec/java_home -v $1`
}

# clangd lsp
function compile-commands() {
	if [[ -z $1 ]]; then
		echo "compile-commands path/to/PROJECT.xcodeproj build_output"
		return
	fi

	filename=$(basename "$1")
	project_name="${filename%.*}"
	dirname=$(dirname "$1")

	xcodebuild -project "$1" -scheme "$project_name" -derivedDataPath "$dirname/build" | \
		xcpretty -r json-compilation-database --output $2/compile_commands.json

	echo "$dirname/build/$project_name/Debug/$project_name.app"
}

# get process ids
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

# print timezones
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

# remove ansi colors
function decolor() {
	sed "s/\x1b\[[^m]*m//g"
}

# search packages and install
function install() {
	local selected_package=$(brew search "$1" | fzf --preview 'brew info {1}' --preview-window=right:70%)

	if [[ -n "$selected_package" ]]; then
		read -q "REPLY?brew install $selected_package? (y/N) "
		echo "" # newline

		if [[ "$REPLY" =~ ^[Yy]$ ]]; then
			echo "Installing $selected_package..."
			brew install "$selected_package"
		else
			echo "Cancelled"
		fi
	else
		echo "Nothing selected."
	fi
}