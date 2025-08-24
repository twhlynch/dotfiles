local DEBUG = false

-- PR Review Comments
local reviews = require("twhlynch.personal-plugins.reviews")

reviews.setup({
	interval = 1800, -- 30 minutes
	debug = DEBUG,
	highlight = "#7E98E8",
	integrations = {
		scrollbar = false,
	},
})

vim.keymap.set({ "n" }, "<leader>K", function() -- match lsp hover cos im lazy
	reviews.get_current_line_comments()
end, { noremap = true, silent = true, desc = "Show line PR Review Comments" })

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

-- formatting reminder
local reminder = require("twhlynch.personal-plugins.reminder")

reminder.setup({
	-- notify = function(str)
	-- 	vim.notify(str, vim.log.levels.WARN)
	-- end,
	notify = print, -- output function
	debug = DEBUG,
})

-- h and l open and close folds
local origami = require("twhlynch.personal-plugins.origami")

origami.setup({
	debug = DEBUG,
})

-- jump file pairs
local pear = require("twhlynch.personal-plugins.pear")

pear.setup({
	source_exts = { "c", "cpp", "frag", "html" },
	header_exts = { "h", "hpp", "vert", "js", "css" },
	debug = DEBUG,
})

vim.keymap.set({ "n" }, "<leader>jp", function()
	pear.jump_pair()
end, { noremap = true, silent = true, desc = "Jump file pair" })

-- refreshing
vim.keymap.set({ "n" }, "<leader>RR", function()
	reviews.get_pr_review_comments()
	oil_git.update_git_status()
end, { noremap = true, silent = true, desc = "Refresh Custom Plugins" })
