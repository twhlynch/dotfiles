return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				enabled = false,
			},
		},
		prompt = {
			enabled = false,
		},
	},
	keys = {
		-- stylua: ignore start
		{ "<leader>F", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		{ "<leader>T", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		-- stylua: ignore end
	},
}