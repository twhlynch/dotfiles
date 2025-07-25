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

set({ "n", "v" }, "<leader>y", [["+y]], desc("Yank to system clipboard"))
set({ "n" }, "<leader>Y", [["+Y]], desc("Yank line to system clipboard"))
set({ "n", "v" }, "<leader>A", "ggVG", desc("Select all"))
set({ "n", "v" }, "<A-j>", "ddp", desc("Move line down"))
set({ "n", "v" }, "<A-k>", "ddkkp", desc("Move line up"))
set({ "v" }, "<", "<gv", desc("Unindent and stay in visual"))
set({ "v" }, ">", ">gv", desc("Indent and stay in visual"))
set({ "n" }, "tt", "<cmd>b#<CR>", desc("Jump to last buffer"))
set({ "n" }, "h", lib.h, desc("Origami h"))
set({ "n" }, "l", lib.l, desc("Origami l"))
set({ "n" }, "<leader>cell", "<cmd>CellularAutomaton make_it_rain<CR>", desc("Make it rain"))
set({ "n" }, "<leader>j", lib.jump_pair, desc("Jump file pair"))
set({ "n" }, "<leader>F", lib.format, desc("Format current buffer"))
set({ "n" }, "<leader>z", lib.toggle_wrap, desc("Toggle wrapping"))

command("W", "w")
command("Q", "q")
