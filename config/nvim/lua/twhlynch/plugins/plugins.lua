return {
	-- "twhlynch/nvim-plugins",
	dir = "~/Documents/Personal/nvim-plugins",
	dependencies = {
		"nvim-mini/mini.hipatterns", -- for hipatterns
		"stevearc/oil.nvim", -- for oil_git
		"petertriho/nvim-scrollbar", -- for regions, scrollbar_marks, and scrollbar_todo
		"neovim/nvim-lspconfig", -- for copy_lspconfig
		"stevearc/conform.nvim", -- for reminder
		"folke/todo-comments.nvim", -- for scrollbar_todo
	},
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
		hipatterns = {
			enabled = true,
			hex = true,
			rgb = true,
			ansi = true,
			env = true,
			css = true,
			patterns = {
				hex = "0?[#x]%x%x%x%x?%x?%x?%x?%x?%f[%W]", -- 3 - 8 length hex. # or 0x
				rgb = "rgba?%(%d%d?%d?, ?%d%d?%d?, ?%d%d?%d?,? ?%d?%.?%d%)", -- rgb or rgba css color
				ansi = "%[[34]8;2;%d%d?%d?;%d%d?%d?;%d%d?%d?m%f[%W]", -- r;g;b ansi code for fg or bg
				env = '".-"', -- env values
			},
		},
		scrollbar_todo = {
			enabled = true,
		},
		nolint = {
			enabled = true,
			key = "gcs",
		},
	},
	keys = {
	---@diagnostic disable: undefined-global
	-- stylua: ignore start
	{ "h", function() Plugins.origami.h() end, desc = "Origami h", },
	{ "l", function() Plugins.origami.l() end, desc = "Origami l", },
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
