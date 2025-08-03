return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		lazygit = { enabled = true },
		git = { enabled = true },
		image = {
			enabled = true,
			math = { enabled = true },
		},
		bigfile = { enabled = true },
	},
	keys = {
		{
			"<leader>bg",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
	},
}
