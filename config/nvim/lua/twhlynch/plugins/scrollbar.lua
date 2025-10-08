return {
	"petertriho/nvim-scrollbar",
	opts = {
		max_lines = 10000,
		throttle_ms = 0,
		excluded_buftypes = {
			"terminal",
			"nowrite",
			"nofile",
			"prompt",
		},
		handlers = {
			cursor = true,
			diagnostic = true,
			gitsigns = true,
			handle = true,
			-- search = true,
		},
		marks = {
			GitAdd = {
				highlight = "Added",
			},
			GitChange = {
				highlight = "Changed",
			},
			GitDelete = {
				highlight = "Removed",
			},
		},
	},
	init = function()
		-- reduce lag
		local scrollbar = require("scrollbar")
		local old_render = scrollbar.render
		scrollbar.render = function()
			vim.schedule(old_render)
		end
	end,
}
