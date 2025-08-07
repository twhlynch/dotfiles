return {
	{ "eandrju/cellular-automaton.nvim" },
	{
		"nullromo/fishtank.nvim",
		opts = {
			screensaver = {
				enabled = true,
				timeout = 1000 * 60, -- 1 minute
				sprite = {
					right = "><>",
					left = "<><",
				},
			},
		},
		config = function(_, opts)
			local fishtank = require("fishtank")
			fishtank.setup(opts)
		end,
	},
}
