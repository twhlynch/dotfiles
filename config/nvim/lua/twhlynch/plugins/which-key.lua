return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		local state = require("which-key.state")
		local old_start = state.start
		state.start = function(...)
			state.recursion = 0 -- disable recursion detection
			old_start(...)
		end
	end,
}
