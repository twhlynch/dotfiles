return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	opts = {},
	keys = {
		-- stylua: ignore start
		{ "<leader>S", function() require("fff").find_files() end, desc = "Open file picker", },
		-- stylua: ignore stop
	},
}
