return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			excluded_buftypes = {
				"terminal",
				"nowrite",
				"nofile",
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
	end,
}
