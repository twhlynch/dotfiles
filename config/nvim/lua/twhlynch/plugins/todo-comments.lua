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

		vim.keymap.set("n", "]c", function()
			require("todo-comments").jump_next()
		end, { desc = "Next todo comment" })

		vim.keymap.set("n", "[c", function()
			require("todo-comments").jump_prev()
		end, { desc = "Previous todo comment" })
	end,
}
