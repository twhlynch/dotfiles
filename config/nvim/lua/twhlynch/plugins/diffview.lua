return {
	"sindrets/diffview.nvim",
	dependencies = { 'nvim-web-devicons' },
	config = function()
		local diffview = require("diffview")
		vim.keymap.set("n", "<leader>pg", function() diffview.open() end, { desc = "Open Diffview" })
		vim.keymap.set("n", "<leader>pG", function() diffview.close() end, { desc = "Close Diffview" })
	end
}
