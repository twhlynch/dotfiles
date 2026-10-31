return {
	"petertriho/nvim-scrollbar",
	branch = "refactor/v2",
	opts = {
		exclude = {
			buftypes = {
				terminal = true,
				nowrite = true,
				nofile = true,
				prompt = true,
			},
		},
		providers = {
			cursor = true,
			diagnostic = true,
			gitsigns = true,
			search = true,
			marks = true,
		},
		scrollbar = {
			max_lines = 10000,
			placement = { zindex = 50 },
			layout = {
				columns = {
					{ "thumb", "marks" }, -- no track
				},
			},
		},
		marks = {
			Error = { text = { "-", "=" }, priority = 2 },
			Warn = { text = { "-", "=" }, priority = 3 },
			Info = { text = { "-", "=" }, priority = 4 },
			Hint = { text = { "-", "=" }, priority = 5 },
			Search = { text = { "⠒", "⠭" }, priority = 1 },
			Mark = { text = {}, priority = 1 },
			GitAdd = { text = { "┆" }, priority = 9 },
			GitChange = { text = { "┆" }, priority = 7 },
			GitDelete = { text = { "▁" }, priority = 8 },
		},
	},
}
