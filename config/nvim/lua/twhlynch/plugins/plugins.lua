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
			key = "<leader>bf",
		},
		copy_lspconfig = {
			enabled = true,
			key = "<leader>LSP",
		},
		fff = {
			enabled = true,
			key = "<leader><leader>",
		},
		origami = {
			enabled = true,
		},
		pear = {
			enabled = true,
			key = "<leader>jp",
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
			ignore_key = "<leader>ii",
			toggle_key = "<leader>iI",
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
			key = "<leader>ih",
		},
		auto_commit = {
			enabled = false,
			keymap = "<leader>commit",
		},
		templates = { enabled = true },
		toggle = { enabled = true },
		typst_preview = { enabled = true },
	},
}
