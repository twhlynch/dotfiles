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
				pattern = [[\b(KEYWORDS)(\(.*\))?:]],
			},
		})

		vim.keymap.set("n", "]c", todo_comments.jump_next, { desc = "Next todo comment" })
		vim.keymap.set("n", "[c", todo_comments.jump_prev, { desc = "Previous todo comment" })
	end,
}
