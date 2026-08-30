return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-mini/mini.icons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		close_if_last_window = true,
		window = {
			width = 32,
			mappings = {
				["z"] = "close_all_subnodes",
				["Z"] = "expand_all_subnodes",
			},
		},
		source_selector = {
			winbar = true,
			sources = { { source = "filesystem" } },
		},
		filesystem = {
			group_empty_dirs = true,
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
				hide_ignored = false,
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
		{ "<leader>pp", ":Neotree close<CR>", desc = "Close tree" },
	},
	init = function()
		local function toggle(source)
			local command = require("neo-tree.command")
			local oil = require("oil")
			local oil_util = require("oil.util")

			local is_oil = oil_util.is_oil_bufnr(0)
			command.execute({
				source = source,
				toggle = true,
				dir = is_oil and vim.fn.getcwd() or nil,
				reveal = true,
				reveal_file = is_oil and oil.get_current_dir() or nil,
			})
		end

		vim.keymap.set({ "n", "v", "x" }, "<leader>pv", function()
			toggle()
		end, { desc = "File tree" })
		vim.keymap.set({ "n", "v", "x" }, "<leader>pb", function()
			toggle("buffers")
		end, { desc = "Buffer tree" })
		vim.keymap.set({ "n", "v", "x" }, "<leader>pm", function()
			toggle("git_status")
		end, { desc = "Diff tree" })
	end,
}
