return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		opts = {
			focus = true,
		},
		config = function()
			require("trouble").setup({
				icons = true,
			})
		end,
	},
}
