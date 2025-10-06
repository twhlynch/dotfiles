return {
	{
		"nvim-mini/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.cursorword",
		version = false,
		config = function()
			require("mini.cursorword").setup()
		end,
	},
	-- {
	-- 	"nvim-mini/mini.comment",
	-- 	version = false,
	-- 	config = function()
	-- 		require("mini.comment").setup()
	-- 	end,
	-- },
	{
		"nvim-mini/mini.operators",
		version = false,
		config = function()
			require("mini.operators").setup({
				evaluate = {
					prefix = "<leader>=",
					func = nil,
				},
				exchange = {
					prefix = "Gox",
					reindent_linewise = true,
				},
				multiply = {
					prefix = "Gom",
					func = nil,
				},
				replace = {
					prefix = "Gor",
					reindent_linewise = true,
				},
				sort = {
					prefix = "Gos",
					func = nil,
				},
			})
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({
				custom_surroundings = {
					["$"] = { output = { left = "$$ ", right = " $$" } },
					["9"] = { output = { left = "(", right = ")" } },
				},
				highlight_duration = 500,
				mappings = {
					add = "sa",
					delete = "sd",
					find = "sf",
					find_left = "sF",
					highlight = "sh",
					replace = "sr",
					update_n_lines = "sn",
					suffix_last = "l",
					suffix_next = "n",
				},
				n_lines = 20,
				respect_selection_type = false,
				search_method = "cover",
				silent = false,
			})
		end,
	},
}
