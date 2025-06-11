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
