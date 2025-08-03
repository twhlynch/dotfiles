return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-web-devicons" },
	config = function()
		local diffview = require("diffview")
		vim.keymap.set("n", "<leader>pg", diffview.open, { desc = "Open Diffview" })
		vim.keymap.set("n", "<leader>pG", diffview.close, { desc = "Close Diffview" })
	end,
}
