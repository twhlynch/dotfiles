vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader><leader>", function()
	vim.cmd("so $MYVIMRC")
end)

keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

-- keymap.set("n", "<leader>F", vim.lsp.buf.format)
keymap.set("n", "<leader>F", function()
	require("conform").format({ lsp_format = "fallback" })
end)

keymap.set("n", "<leader>cell", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<A-j>", "ddp", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "ddkkp", { noremap = true, silent = true })

-- h l to open close folds from Origami (https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/features/fold-keymaps.lua)

local function normal(cmdStr)
	vim.cmd.normal({ cmdStr, bang = true })
end

-- `h` closes folds when at the beginning of a line.
local function h()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local col = vim.api.nvim_win_get_cursor(0)[2]
		if col == 0 then
			local wasFolded = pcall(normal, "zc")
			if not wasFolded then
				normal("h")
			end
		else
			normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
local function l()
	local count = vim.v.count1 -- count needs to be saved due to `normal` affecting it
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1
		local action = isOnFold and "zo" or "l"
		pcall(normal, action)
	end
end

vim.keymap.set("n", "h", function()
	h()
end, { desc = "Origami h" })
vim.keymap.set("n", "l", function()
	l()
end, { desc = "Origami l" })
