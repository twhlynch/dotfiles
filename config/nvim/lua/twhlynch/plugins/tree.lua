return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	keys = { "<leader>pv", "<leader>pm", "<leader>pb", "<leader>pp" },
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
				follow_current_file = {
					enabled = true,
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
			},
		})

		local function desc(description)
			return { noremap = true, silent = true, desc = description }
		end

		vim.keymap.set("n", "<leader>pv", ":Neotree toggle<CR>", desc("File tree"))
		vim.keymap.set("n", "<leader>pp", ":Neotree close<CR>", desc("Close tree"))
		vim.keymap.set("n", "<leader>pb", ":Neotree toggle buffers<CR>", desc("Buffer tree"))
		vim.keymap.set("n", "<leader>pm", ":Neotree toggle git_status<CR>", desc("Diff tree"))
	end,
}
