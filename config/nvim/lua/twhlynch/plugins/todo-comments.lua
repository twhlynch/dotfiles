return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		highlight = {
			pattern = [[.*<((KEYWORDS).*)\s*:]],
		},
		search = {
			pattern = [[\b(KEYWORDS)(\(.*\))?:]],
		},
	},
	keys = {
		-- stylua: ignore start
		{ "]c", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
		{ "[c", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
		-- stylua: ignore end
	},
}
