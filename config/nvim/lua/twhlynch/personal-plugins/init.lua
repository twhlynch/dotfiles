local reviews = require("twhlynch.personal-plugins.reviews")

-- <leader>R<key> for refreshing
vim.keymap.set("n", "<leader>Rc", function()
	reviews.get_pr_review_comments()
end, { desc = "Refresh PR Review Comments" })

vim.keymap.set("n", "<leader>K", function() -- match lsp hover cos im lazy
	reviews.get_current_line_comments()
end, { desc = "Show line PR Review Comments" })
