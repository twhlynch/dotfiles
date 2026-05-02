-- TODO: override fff picker to look and behave like snacks
return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	opts = {
		prompt = " ",
		layout = {
			width = 0.9,
			prompt_position = "top",
			flex = {
				wrap = "bottom",
			},
		},
	},
	lazy = true,
	keys = {
		-- stylua: ignore start
		{ "<leader>S", function() require("fff").find_files() end, desc = "Open file picker", },
		-- stylua: ignore stop
	},
}
