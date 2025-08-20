return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")
		todo_comments.setup({
			highlight = {
				pattern = [[.*<((KEYWORDS).*)\s*:]],
			},
			search = {
				pattern = [[\b(KEYWORDS)(\(.*\))?:]]
			}
		})
	end,
}
