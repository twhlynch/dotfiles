return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		lazygit = { enabled = true },
		git = { enabled = true },
		bigfile = { enabled = true },
		picker = {
			enabled = true,
			matcher = {
				frecency = true,
			},
		},
		image = {
			enabled = false,
			math = { enabled = true },
			convert = {
				notify = false,
				magick = {
					vector = { "-density", 192, "-background", "none", "{src}[0]" },
				},
			},
		},
		notifier = {
			enabled = true,
			timeout = 5000,
		},
	},
	keys = {
		-- stylua: ignore start
		{ "<leader>bg", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
		{ "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } }, -- idk i cant decide
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },

		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History" },
		{ "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>s", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>r", function() Snacks.picker.recent() end, desc = "Recent" },
		{ "<leader>g/", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		{ "<leader>hh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>d", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		{ "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>t", function() Snacks.picker.todo_comments() end, desc = "Todo" },
		{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
		{ "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		{ "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
		{ "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		-- stylua: ignore end
	},
}
