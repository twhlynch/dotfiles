return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		lazygit = { enabled = true },
		git = { enabled = true },
		image = {
			enabled = true,
			math = { enabled = true },
		},
		bigfile = { enabled = true },
		-- indent = {
		-- 	indent = {
		-- 		enabled = false,
		-- 	},
		-- 	chunk = {
		-- 		enabled = true,
		-- 		char = {
		-- 			horizontal = "─",
		-- 			vertical = "│",
		-- 			corner_top = "╭",
		-- 			corner_bottom = "╰",
		-- 			arrow = "─",
		-- 		},
		-- 	},
		-- },
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
