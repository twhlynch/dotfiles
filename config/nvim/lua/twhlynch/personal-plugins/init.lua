local DEBUG = false

local function load_plugin(name, opts)
	opts = opts or {}
	opts.debug = opts.debug or DEBUG

	local plugin = require("twhlynch.personal-plugins." .. name)
	if plugin.setup then
		plugin.setup(opts)
	end

	return plugin
end

-- PR Review Comments
local reviews = load_plugin("reviews", {
	interval = 1800, -- 30 minutes
	highlight = "#7E98E8",
	integrations = {
		scrollbar = false,
	},
})

-- oil git integration
local oil_git = load_plugin("oil-git", {
	highlight = {
		OilGitAdded = { fg = "#7fa563" },
		OilGitModified = { fg = "#f3be7c" },
		OilGitDeleted = { fg = "#d8647e" },
		OilGitRenamed = { fg = "#cba6f7" },
		OilGitUntracked = { fg = "#c48282" },
	},
})

-- formatting reminder
local reminder = load_plugin("reminder", { notify = print })

-- h and l open and close folds
local origami = load_plugin("origami", {})

-- jump file pairs
local pear = load_plugin("pear", {
	source_exts = { "c", "cpp", "frag", "html" },
	header_exts = { "h", "hpp", "vert", "js", "css" },
})

local regions = load_plugin("regions", {
	region_markers = {
		"MARK: ",
		"#region ",
		"\\section{",
	},
})
local marks = load_plugin("marks")

local fff = load_plugin("fff")

local set = vim.keymap.set
local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

set({ "n" }, "<leader>K", reviews.get_current_line_comments, desc("Show line PR Review Comments"))
set({ "n" }, "<leader>jp", pear.jump_pair, desc("Jump file pair"))
set({ "n" }, "]r", regions.goto_next_region, desc("Next region"))
set({ "n" }, "[r", regions.goto_prev_region, desc("Previous region"))
set({ "n" }, "<leader><leader>", fff.fff, desc("FFF"))

-- refreshing
set({ "n" }, "<leader>RR", function()
	reviews.get_pr_review_comments()
	oil_git.update_git_status()
end, desc("Refresh Custom Plugins"))
