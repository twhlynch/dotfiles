return {
	"petertriho/nvim-scrollbar",
	config = function()
		local scrollbar = require("scrollbar")
		scrollbar.setup({
			max_lines = 10000,
			throttle_ms = 300,
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
		})

		-- so laggy
		local old_render = scrollbar.render
		scrollbar.render = function()
			vim.schedule(old_render)
		end
	end,
}
