vim.g.mapleader = " "

local set = vim.keymap.set

local function map(modes, lhs, rhs, desc)
	vim.keymap.set(modes, lhs, rhs, { desc = desc })
end

-- mistypes
vim.cmd([[cabbrev W w]])
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev WQ wq]])
vim.cmd([[cabbrev wQ wq]])

-- useful
map({ "n", "v", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
map({ "n", "v", "x" }, "<A-p>", '"0p', "Paste last yanked register")
map({ "n", "v", "x" }, "<leader>w", "<C-w>", "Window commands")
map({ "n" }, "<leader>A", "ggVG", "Select all")
map({ "x" }, "/", "<esc>/\\%V", "Search in selection")
-- big move
map({ "n" }, "H", "^")
map({ "n" }, "L", "$")
-- paste above or below
map({ "n" }, "[p", '<Cmd>exe "put! " . v:register<CR>', "Paste Above")
map({ "n" }, "]p", '<Cmd>exe "put "  . v:register<CR>', "Paste Below")
-- moving lines
map({ "i" }, "<A-j>", "<Esc>:m .+1<cr>==gi", "Move line down")
map({ "i" }, "<A-k>", "<Esc>:m .-2<cr>==gi", "Move line up")
map({ "n" }, "<A-j>", ":m .+1<cr>==", "Move line down")
map({ "n" }, "<A-k>", ":m .-2<cr>==", "Move line up")
map({ "x" }, "<A-j>", ":m '>+1<CR>gv=gv", "Move lines down")
map({ "x" }, "<A-k>", ":m '<-2<CR>gv=gv", "Move lines up")
-- center search
map({ "n", "v" }, "<A-n>", "nzz", "Center next match")
map({ "n", "v" }, "<A-N>", "Nzz", "Center previous match")
-- indenting
map({ "v" }, "<", "<gv", "Unindent and stay in visual")
map({ "v" }, ">", ">gv", "Indent and stay in visual")
-- jumping
map({ "n" }, "<leader>jo", "<cmd>b#<CR>", "Jump to last buffer")
-- toggles
map({ "n" }, "<leader>z", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping is " .. (vim.wo.wrap and "ON" or "OFF"))
end, "Toggle wrapping")
map({ "n" }, "<leader>hl", function()
	vim.o.hlsearch = not vim.o.hlsearch
	print("Search highlighting is " .. (vim.o.hlsearch and "ON" or "OFF"))
end, "Toggle search highlight")
-- next prevs
map({ "n" }, "]e", function()
	vim.diagnostic.goto_next({
		severity = vim.diagnostic.severity.ERROR,
	})
end, "Jump to the next error in the current buffer")
map({ "n" }, "[e", function()
	vim.diagnostic.goto_prev({
		severity = vim.diagnostic.severity.ERROR,
	})
end, "Jump to the previous error in the current buffer")
-- macros
map({ "n" }, "<leader>mM", "<cmd>%s/\\r//<cr>", "Remove trailing ^M")
map({ "n" }, "<leader>mx", ":!chmod +x %<CR><CR>", "chmod +x")
map({ "n" }, "<leader>mc", "yygccp", "Duplicate and comment out line")
map({ "x" }, "<leader>mr", ":<esc>:%s/\\%V[^A-Za-z0-9]/ /g<CR>", "Clean selection for type")
map({ "n" }, "<leader>mm", ":lua vim.fn.setreg('q', table.concat(vim.fn.readfile(vim.fn.expand('%'), 'b'), '\n'))", "Load file into register q")
