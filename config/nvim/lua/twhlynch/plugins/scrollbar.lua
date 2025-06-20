return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			excluded_buftypes = {
				"terminal",
				"nowrite",
				"nofile",
			},
		})
	end,
}
