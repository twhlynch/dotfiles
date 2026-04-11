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
		notebook = {
			enabled = true,
			-- stylua: ignore
			custom_theme_colors = {
				"#c48282", "#7e98e8", "#e0a363", "#7fa563", "#d8647e", "#6e94b2",
				"#4878CF", "#6ACC65", "#D65F5F", "#B47CC7", "#C4AD66", "#77BEDB",
			},

			keybind_prefix = "<leader>c",
			max_output_lines = 10,
			custom_plot_theme = true,

			strings = {
				output_border = "┃   ",
				cell_border = "─",
				cell_executed = " ",
				cell_running = " ",
				truncated_output = "%s more lines",
				image_output = " × %s",
			},
		},
		tasks = {
			enabled = true,
			keybind = "<leader><CR>",
			sign_icon = "",
		},
		auto_commit = {
			enabled = false,
			keymap = "<leader>commit",
		},
		elk = {
			enabled = true,
			filetypes = { "asm" },
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
	{ "<leader>ii", function() Plugins.reminder.ignore_buffer() end, desc = "Toggle ignoring format reminder for buffer", },
	{ "<leader>iI", function() Plugins.reminder.toggle() end, desc = "Toggle format reminder", },
	{ "<leader>LSP", function() Plugins.copy_lspconfig.copy_lsp() end, desc = "Copy lsp config", },
	{ "<leader><leader>", function() Plugins.fff.fff() end, desc = "FFF", },
	{ "<leader>Ro", function() Plugins.oil_git.update_git_status() end, desc = "Refresh Oil Git", },
	{ "<leader>ih", mode = { "n", "x" }, function() Plugins.inlay.inject_inlay_hints() end, desc = "Inject inlay hints", },
		-- stylua: ignore end
	},
}
