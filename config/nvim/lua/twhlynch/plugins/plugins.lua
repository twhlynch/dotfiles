return {
	"twhlynch/nvim-plugins",
	lazy = false,
	opts = {
		blame = {
			enabled = true,
		},
		copy_lspconfig = {
			enabled = true,
		},
		fff = {
			enabled = true,
		},
		oil_git = {
			enabled = true,
			highlight = {
				OilGitAdded = { fg = "#7fa563" },
				OilGitModified = { fg = "#f3be7c" },
				OilGitDeleted = { fg = "#d8647e" },
				OilGitRenamed = { fg = "#cba6f7" },
				OilGitUntracked = { fg = "#c48282" },
			},
		},
		origami = {
			enabled = true,
		},
		pear = {
			enabled = true,
			source_exts = { "c", "cpp", "frag", "html" },
			header_exts = { "h", "hpp", "vert", "js", "css" },
		},
		regions = {
			enabled = true,
			region_markers = {
				"MARK: ",
				"#region ",
			},
		},
		reminder = {
			enabled = true,
			notify = print,
		},
		scrollbar_marks = {
			enabled = true,
		},
		surround = {
			enabled = true,
			prefix = "s",
			mapping = {
				["()90"] = { "(", ")" },
				["[]"] = { "[", "]" },
				["<>"] = { "<", ">" },
				["{}"] = { "{", "}" },
				["$4"] = { "$$ ", " $$" },
				["|"] = { "|" },
				["'"] = { "'" },
				['"'] = { '"' },
				["`"] = { "`" },
				["*"] = { "*" },
				["_"] = { "_" },
				["%"] = { "%" },
			},
		},
	},
	keys = {
	---@diagnostic disable: undefined-global
	-- stylua: ignore start
	{ "h", function() Plugins.origami.h() end, desc = "Origami h", },
	{ "l", function() Plugins.origami.l() end, desc = "Origami l", },
	{ "<leader>jp", function() Plugins.pear.jump_pair() end, desc = "Jump file pair", },
	{ "<leader>jp", function() Plugins.pear.jump_pair() end, desc = "Jump file pair", },
	{ "]r", function() Plugins.regions.goto_next_region() end, desc = "Next region", },
	{ "[r", function() Plugins.regions.goto_prev_region() end, desc = "Previous region", },
	{ "<leader>bf", function() Plugins.blame.show_blame() end, desc = "Show file blame", },
	{ "<leader>i", function() Plugins.reminder.ignore_buffer() end, desc = "Toggle ignoring format reminder for buffer", },
	{ "<leader>I", function() Plugins.reminder.toggle() end, desc = "Toggle format reminder", },
	{ "<leader>LSP", function() Plugins.copy_lspconfig.copy_lsp() end, desc = "Copy lsp config", },
	{ "<leader><leader>", function() Plugins.fff.fff() end, desc = "FFF", },
	{ "<leader>Ro", function() Plugins.oil_git.update_git_status() end, desc = "Refresh Oil Git", },
		-- stylua: ignore end
	},
}
