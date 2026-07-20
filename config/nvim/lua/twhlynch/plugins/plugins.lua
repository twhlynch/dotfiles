return {
	-- "twhlynch/nvim-plugins",
	dir = "~/Documents/Personal/nvim-plugins",
	dependencies = {
		"nvim-mini/mini.hipatterns", -- for hipatterns
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
		origami = {
			enabled = true,
		},
		pear = {
			enabled = true,
			pairs = {
				{
					source_dirs = { "src", "source", "sources" },
					header_dirs = { "include", "includes" },
					source_exts = { "cpp", "c", "cc", "cxx" },
					header_exts = { "hpp", "h", "hxx" },
				},
				{
					source_exts = { "frag", "fs" },
					header_exts = { "vert", "vs" },
				},
				{
					source_exts = { "html" },
					header_exts = { "js", "css" },
				},
			},
		},
		regions = {
			enabled = true,
			region_markers = {
				"MARK: ",
				"#region ",
			},
			divider = {
				enabled = true,
				hl_group = "RegionDivider",
				char = "─",
			},
			keys = {
				next = "]r",
				prev = "[r",
			},
		},
		reminder = {
			enabled = true,
			notify = print,
			numbers = true,
		},
		scrollbar_marks = {
			enabled = true,
		},
		surround = {
			enabled = true,
			prefix = "s",
		},
		hipatterns = {
			enabled = true,
			hex = true,
			rgb = true,
			ansi = true,
			env = true,
			css = true,
			redact = true,
		},
		scrollbar_todo = {
			enabled = true,
		},
		nolint = {
			enabled = true,
			key = "gcs",
		},
		breadcrumbs = {
			enabled = true,
		},
		inlay = {
			enabled = true,
		},
		auto_commit = {
			enabled = false,
			keymap = "<leader>commit",
		},
		templates = { enabled = true },
		toggle = { enabled = true },
	},
	keys = {
	---@diagnostic disable: undefined-global
	-- stylua: ignore start
	{ "h", function() Plugins.origami.h() end, desc = "Origami h", },
	{ "l", function() Plugins.origami.l() end, desc = "Origami l", },
	{ "<leader>jp", function() Plugins.pear.jump_pair() end, desc = "Jump file pair", },
	{ "<leader>bf", function() Plugins.blame.show_blame() end, desc = "Show file blame", },
	{ "<leader>ii", function() Plugins.reminder.ignore_buffer() end, desc = "Toggle ignoring format reminder for buffer", },
	{ "<leader>iI", function() Plugins.reminder.toggle() end, desc = "Toggle format reminder", },
	{ "<leader>LSP", function() Plugins.copy_lspconfig.copy_lsp() end, desc = "Copy lsp config", },
	{ "<leader><leader>", function() Plugins.fff.fff() end, desc = "FFF", },
	{ "<leader>ih", mode = { "n", "x" }, function() Plugins.inlay.inject_inlay_hints() end, desc = "Inject inlay hints", },
		-- stylua: ignore end
	},
}
