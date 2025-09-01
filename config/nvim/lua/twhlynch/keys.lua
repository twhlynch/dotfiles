vim.g.mapleader = " "

local set = vim.keymap.set
local api = vim.api

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

local function command(cmd, does)
	api.nvim_create_user_command(cmd, does, { nargs = 0 })
end

-- useful
set({ "n", "v", "x" }, "<leader>y", '"+y', desc("Yank to system clipboard"))
set({ "n", "v", "x" }, "<leader>w", "<C-w>", desc("Window commands"))
set({ "n" }, "<leader>A", "ggVG", desc("Select all"))
set({ "n" }, "<leader>X", ":!chmod +x %<CR><CR>:set filetype=sh<CR>", desc("Chmod +x and set .sh"))
set({ "n" }, "g/", "*", desc("Next current word"))
set({ "x" }, "/", "<esc>/\\%V", desc("Search in selection"))
-- moving lines
set({ "n" }, "<A-j>", "ddp", desc("Move line down"))
set({ "n" }, "<A-k>", "ddkkp", desc("Move line up"))
set({ "v" }, "<A-j>", ":m '>+1<CR>gv=gv", desc("Move line down"))
set({ "v" }, "<A-k>", ":m '<-2<CR>gv=gv", desc("Move line up"))
-- indenting
set({ "v" }, "<", "<gv", desc("Unindent and stay in visual"))
set({ "v" }, ">", ">gv", desc("Indent and stay in visual"))
-- jumping
set({ "n" }, "<leader>jo", "<cmd>b#<CR>", desc("Jump to last buffer"))
set({ "n" }, "<leader>jl", "<cmd>bp<CR>", desc("Jump to previous buffer"))
set({ "n" }, "<leader>jr", "<cmd>bn<CR>", desc("Jump to next buffer"))
-- toggles
set({ "n" }, "<leader>z", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping is " .. (vim.wo.wrap and "ON" or "OFF"))
end, desc("Toggle wrapping"))
set({ "n" }, "<leader>hl", function()
	vim.o.hlsearch = not vim.o.hlsearch
	print("Search highlighting is " .. (vim.o.hlsearch and "ON" or "OFF"))
end, desc("Toggle search highlight"))

-- vscode like surround in visual mode
local function surround(pref, suf, trigger)
	local mov_right = string.rep("l", #pref)
	local adjust_selection = string.rep("l", #pref + #suf)
	-- stylua: ignore
	vim.keymap.set({ "v" }, "s" .. trigger, "<esc>`<i" .. pref .. "<esc>`>" .. mov_right .. "a" .. suf .. "<esc>gv" .. adjust_selection, desc("Surround with " .. pref .. " " .. suf))
end

local function setup_surround(tbl)
	for _, surr in ipairs(tbl) do
		local pref = table.remove(surr, 1)
		local suf = table.remove(surr, 1)

		for _, trigger in ipairs(surr) do
			surround(pref, suf, trigger)
		end

		if #surr == 0 then
			local p, s = pref:sub(1, 1), suf:sub(1, 1)
			surround(pref, suf, p)
			if p ~= s then
				surround(pref, suf, s)
			end
		end
	end
end

setup_surround({
	{ '"', '"' },
	{ "'", "'" },
	{ "`", "`" },
	{ "(", ")", "(", ")", "9", "0" },
	{ "[", "]" },
	{ "{", "}" },
	{ "<", ">" },
	{ "|", "|" },
	{ "*", "*" },
	{ "_", "_" },
	{ "$$ ", " $$", "$", "4" },
})

-- mistypes
command("W", "w")
command("Q", "q")