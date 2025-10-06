vim.g.mapleader = " "

local set = vim.keymap.set

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

-- mistypes
vim.cmd([[cabbrev W w]])
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev WQ wq]])
vim.cmd([[cabbrev wQ wq]])

-- useful
set({ "n", "v", "x" }, "<leader>y", '"+y', desc("Yank to system clipboard"))
set({ "n", "v", "x" }, "<A-p>", '"0p', desc("Paste last yanked register"))
set({ "n", "v", "x" }, "<leader>w", "<C-w>", desc("Window commands"))
set({ "n" }, "<leader>A", "ggVG", desc("Select all"))
set({ "x" }, "/", "<esc>/\\%V", desc("Search in selection"))
-- big move
set({ "n" }, "H", "^")
set({ "n" }, "L", "$")
-- moving lines
set("i", "<A-j>", "<Esc>:m .+1<cr>==gi", desc("Move line down"))
set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", desc("Move line up"))
set({ "n" }, "<A-j>", ":m .+1<cr>==", desc("Move line down"))
set({ "n" }, "<A-k>", ":m .-2<cr>==", desc("Move line up"))
set({ "x" }, "<A-j>", ":m '>+1<CR>gv=gv", desc("Move lines down"))
set({ "x" }, "<A-k>", ":m '<-2<CR>gv=gv", desc("Move lines up"))
-- center search
set({ "n", "v" }, "<A-n>", "nzz", desc("Center next match"))
set({ "n", "v" }, "<A-N>", "Nzz", desc("Center previous match"))
-- indenting
set({ "v" }, "<", "<gv", desc("Unindent and stay in visual"))
set({ "v" }, ">", ">gv", desc("Indent and stay in visual"))
-- jumping
set({ "n" }, "<leader>jo", "<cmd>b#<CR>", desc("Jump to last buffer"))
-- toggles
set({ "n" }, "<leader>z", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping is " .. (vim.wo.wrap and "ON" or "OFF"))
end, desc("Toggle wrapping"))
set({ "n" }, "<leader>hl", function()
	vim.o.hlsearch = not vim.o.hlsearch
	print("Search highlighting is " .. (vim.o.hlsearch and "ON" or "OFF"))
end, desc("Toggle search highlight"))
-- next prevs
set({ "n" }, "]e", function()
	vim.diagnostic.goto_next({
		severity = vim.diagnostic.severity.ERROR,
	})
end, desc("Jump to the next error in the current buffer"))
set({ "n" }, "[e", function()
	vim.diagnostic.goto_prev({
		severity = vim.diagnostic.severity.ERROR,
	})
end, desc("Jump to the previous error in the current buffer"))
-- macros
set({ "n" }, "<leader>mm", "<cmd>%s/\\r//<cr>", desc("Remove trailing ^M"))
set({ "n" }, "<leader>mx", ":!chmod +x %<CR><CR>", desc("chmod +x"))
set({ "n" }, "<leader>mc", "yygccp", desc("Duplicate and comment out line"))
set({ "x" }, "<leader>mr", ":<esc>:%s/\\%V[^A-Za-z0-9]/ /g<CR>", desc("Clean selection for type"))
-- surround visual selection
local function surround(triggers, pref, suff)
	if suff == nil then
		suff = pref
	end
	local cmd = ":<C-u>normal!`>a" .. suff .. "<Esc>`<i" .. pref .. "<Esc>"

	for _, trigger in ipairs(triggers) do
		set({ "v", "x" }, "s" .. trigger, function()
			if vim.fn.mode() == "" then -- visual block
				return cmd .. "`<<C-v>`>" .. string.rep("l", #suff)
			else
				return cmd .. "`<v`>" .. string.rep("l", #pref + #suff)
			end
		end, { noremap = true, silent = true, desc = "Surround selection with " .. pref .. " " .. suff, expr = true })
	end
end
surround({ "'" }, "'", "'")
surround({ '"' }, '"', '"')
surround({ "`" }, "`", "`")
surround({ "(", ")", "9", "0" }, "(", ")")
surround({ "[", "]" }, "[", "]")
surround({ "{", "}" }, "{", "}")
surround({ "<", ">" }, "<", ">")
surround({ "|" }, "|")
surround({ "*" }, "*")
surround({ "_" }, "_")
surround({ "%" }, "%")
surround({ "$", "4" }, "$$ ", " $$")