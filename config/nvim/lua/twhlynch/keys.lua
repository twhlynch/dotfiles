vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader><leader>", function()
	vim.cmd("so $MYVIMRC")
end)

keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>cell", "<cmd>CellularAutomaton make_it_rain<CR>")
