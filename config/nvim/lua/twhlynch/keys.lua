local lib = require("twhlynch.lib") -- functions

vim.g.mapleader = " "

local set = vim.keymap.set
local api = vim.api

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

local function command(cmd, does)
	api.nvim_create_user_command(cmd, does, { nargs = 0 })
end

set({ "n" }, "<leader>o", ":so<CR>", desc("Source current file"))
set({ "n" }, "<leader>w", ":write<CR>", desc("Write current file"))
set({ "n" }, "<leader>q", ":quit<CR>", desc("Quit"))
set({ "n", "v", "x" }, "<leader>y", '"+y', desc("Yank to system clipboard"))
set({ "n", "v", "x" }, "<leader>d", '"+d', desc("Delete to system clipboard"))
set({ "n" }, "<leader>Y", '"+Y', desc("Yank line to system clipboard"))
set({ "n" }, "<leader>A", "ggVG", desc("Select all"))
set({ "n" }, "<A-j>", "ddp", desc("Move line down"))
set({ "n" }, "<A-k>", "ddkkp", desc("Move line up"))
set({ "v" }, "<A-j>", ":m '>+1<CR>gv=gv", desc("Move line down"))
set({ "v" }, "<A-k>", ":m '<-2<CR>gv=gv", desc("Move line up"))
set({ "v" }, "<", "<gv", desc("Unindent and stay in visual"))
set({ "v" }, ">", ">gv", desc("Indent and stay in visual"))
set({ "n" }, "<leader>jo", "<cmd>b#<CR>", desc("Jump to last buffer"))
set({ "n" }, "h", lib.h, desc("Origami h"))
set({ "n" }, "l", lib.l, desc("Origami l"))
set({ "n" }, "<leader>cell", "<cmd>CellularAutomaton make_it_rain<CR>", desc("Make it rain"))
set({ "n" }, "<leader>jp", lib.jump_pair, desc("Jump file pair"))
set({ "n" }, "<leader>lf", lib.format, desc("Format current buffer"))
set({ "n" }, "<leader>z", lib.toggle_wrap, desc("Toggle wrapping"))
set({ "n", "x" }, "<leader>e", lib.open_oil, desc("Open File Explorer"))
set({ "n" }, "<leader>u", vim.cmd.UndotreeToggle, desc("Toggle Undotree"))
set({ "n" }, "<leader>X", ":!chmod +x %<CR><CR>:set filetype=sh<CR>", desc("Chmod +x and set .sh"))

-- vscode like surround in visual mode
lib.setup_surround({
	{ '"', '"' },
	{ "'", "'" },
	{ "`", "`" },
	{ "(", ")", "9", "0" },
	{ "[", "]" },
	{ "{", "}" },
	{ "<", ">" },
	{ "|", "|" },
	{ "*", "*" },
	{ "_", "_" },
})

-- mistypes
command("W", "w")
command("Q", "q")
