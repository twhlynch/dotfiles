
# edit command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X' edit-command-line

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


