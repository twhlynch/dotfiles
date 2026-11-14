return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		prompt = " ",
		title = "FFFiles",
		prompt_vim_mode = true,
		layout = {
			width = 0.9,
			prompt_position = "top",
			flex = {
				wrap = "bottom",
			},
			show_path_first = true,
			title_position = "center",
		},
		file_picker = {
			current_file_label = " ",
			fuzzy_query_highlighting = false,
		},
	},
	lazy = false,
	keys = {
		{
			"<leader><leader>",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			"<leader>?",
			function()
				require("fff").live_grep({
					grep = { modes = { "regex", "fuzzy", "plain", "definition_only" } },
				})
			end,
			desc = "LiFFFe grep",
		},
		{
			"<leader>g?",
			function()
				require("fff").live_grep_under_cursor({
					grep = { modes = { "regex", "fuzzy", "plain", "definition_only" } },
				})
			end,
			mode = { "n", "x" },
			desc = "Search current word / selection",
		},
	},
}
