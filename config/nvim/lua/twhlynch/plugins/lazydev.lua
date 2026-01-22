return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				"~/.local/share/nvim/lazy/",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
