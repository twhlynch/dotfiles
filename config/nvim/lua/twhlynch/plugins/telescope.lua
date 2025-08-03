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
		vim.keymap.set("n", "<leader><C-f>", builtin.find_files, { silent = true, desc = "Find files" })
		vim.keymap.set("n", "<leader><C-g>", builtin.live_grep, { silent = true, desc = "Live grep" })
		vim.keymap.set("n", "<leader><C-r>", ":Telescope oldfiles<CR>", { silent = true })

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}
