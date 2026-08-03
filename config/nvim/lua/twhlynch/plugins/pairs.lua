return {
	"saghen/blink.pairs",
	dependencies = "saghen/blink.lib",
	version = "*",
	build = function()
		require("blink.pairs").download():pwait(60000)
	end,

	opts = {
		mappings = {
			enabled = false,
		},
		highlights = {
			-- set in theme.lua
			groups = { "BlinkPairsOrange", "BlinkPairsPurple", "BlinkPairsBlue" },
			unmatched_group = "BlinkPairsUnmatched",

			matchparen = {
				enabled = false,
			},
		},
	},
}
