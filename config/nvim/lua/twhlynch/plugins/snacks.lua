return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		lazygit = { enabled = true },
		git = { enabled = true },
		bigfile = { enabled = true },
		picker = { enabled = true },
		image = {
			enabled = true,
			math = { enabled = true },
		},
		notifier = {
			enabled = true,
			timeout = 5000,
		},
	},
	keys = {
		{ "<leader>bg", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },

		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History" },
		{ "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>r", function() Snacks.picker.recent() end, desc = "Recent" },
		{ "<leader>F", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		{ "<leader>hh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>d", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		{ "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },

		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
	},
}
