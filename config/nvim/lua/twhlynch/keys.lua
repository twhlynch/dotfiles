vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])