return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	opts = {},
	keys = {
		{
			"<leader>S",
			function()
				require("fff").find_files()
			end,
			desc = "Open file picker",
		},
	},
}
