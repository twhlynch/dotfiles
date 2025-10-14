return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
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
			follow_current_file = {
				enabled = true,
			},
		},
		event_handlers = {
			{
				event = "vim_buffer_enter",
				handler = function()
					if vim.bo.filetype == "neo-tree" then
						-- remove empty line ~
						vim.cmd([[setlocal fillchars=eob:\ ]])
					end
				end,
			},
		},
	},
	keys = {
		{ "<leader>pv", ":Neotree toggle<CR>", desc = "File tree" },
		{ "<leader>pp", ":Neotree close<CR>", desc = "Close tree" },
		{ "<leader>pb", ":Neotree toggle buffers<CR>", desc = "Buffer tree" },
		{ "<leader>pm", ":Neotree toggle git_status<CR>", desc = "Diff tree" },
	},
}
