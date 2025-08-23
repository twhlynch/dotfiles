local DEBUG = false

-- PR Review Comments
local reviews = require("twhlynch.personal-plugins.reviews")

-- <leader>R<key> for refreshing
vim.keymap.set("n", "<leader>Rc", function()
	reviews.get_pr_review_comments()
end, { desc = "Refresh PR Review Comments" })
reviews.setup({
	interval = 1800, -- 30 minutes
	debug = DEBUG,
	highlight = "#7E98E8",
	integrations = {
		scrollbar = false,
	},
})

vim.keymap.set("n", "<leader>K", function() -- match lsp hover cos im lazy
	reviews.get_current_line_comments()
end, { desc = "Show line PR Review Comments" })

-- oil git integration
local oil_git = require("twhlynch.personal-plugins.oil-git")

oil_git.setup({
	highlight = {
		OilGitAdded = { fg = "#7fa563" },
		OilGitModified = { fg = "#f3be7c" },
		OilGitDeleted = { fg = "#d8647e" },
		OilGitRenamed = { fg = "#cba6f7" },
		OilGitUntracked = { fg = "#c48282" },
	},
	debug = DEBUG,
})
