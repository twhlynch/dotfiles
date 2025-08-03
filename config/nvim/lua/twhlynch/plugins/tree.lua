return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = { "<leader>pv", "<leader>pm", "<leader>pb" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			window = { width = 32 },
			source_selector = {
				winbar = true,
				sources = { { source = "filesystem" } },
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
					hide_by_name = {},
				},
			},
			event_handlers = {
				{
					event = "vim_buffer_enter",
					handler = function()
						if vim.bo.filetype == "neo-tree" then
							vim.cmd([[setlocal fillchars=eob:\ ]])
						end
					end,
				},
				-- {
				-- 	event = "WinScrolled",
				-- 	handler = function()
				-- 		if vim.bo.filetype == "neo-tree" or vim.bo.filetype == "oil" then
				-- 			vim.cmd([[setlocal mousescroll=ver:1,hor:0]])
				-- 		else
				-- 			vim.cmd([[setlocal mousescroll=ver:1,hor:1]])
				-- 		end
				-- 	end,
				-- }
			},
		})

		vim.keymap.set("n", "<leader>pv", ":Neotree toggle<CR>", { desc = "File tree", noremap = true, silent = true })
		vim.keymap.set("n", "<leader>pb", ":Neotree toggle buffers<CR>", { desc = "Buffer tree", noremap = true, silent = true })
		vim.keymap.set("n", "<leader>pm", ":Neotree toggle git_status<CR>", { desc = "Diff tree", noremap = true, silent = true })
	end,
}
