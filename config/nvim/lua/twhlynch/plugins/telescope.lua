return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		local builtin = require("telescope.builtin")
		local previewers = require("telescope.previewers")
		vim.keymap.set("n", "<leader>f", builtin.find_files, { silent = true, desc = "Find files" })
		vim.keymap.set("n", "<leader>g", builtin.live_grep, { silent = true, desc = "Live grep" })
		vim.keymap.set("n", "<leader>r", ":Telescope oldfiles<CR>", { silent = true })
		vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>c", builtin.commands, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>co", builtin.colorscheme, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>lt", builtin.treesitter, { desc = "List functions" })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "List functions" })
		vim.keymap.set("n", "<leader>lq", "<cmd>Telescope diagnostics<CR>", { desc = "List functions" })
		vim.keymap.set("n", "<leader>lt", builtin.treesitter, { desc = "List functions" })
		vim.keymap.set('v', '<leader>F', function()
			vim.cmd('normal! "zy')
			builtin.grep_string({ search = vim.fn.getreg('z') })
		end, { desc = "Grep for current selection" })

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}
