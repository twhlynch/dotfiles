return {
	{
		"barrettruth/canola.nvim",
		dependencies = { "nvim-mini/mini.icons" },
		config = function()
			-- helper function to parse output
			local function parse_output(proc)
				local result = proc:wait()
				local ret = {}
				if result.code == 0 then
					for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
						-- Remove trailing slash
						line = line:gsub("/$", "")
						ret[line] = true
					end
				end
				return ret
			end

			-- build git status cache
			local function new_git_status()
				return setmetatable({}, {
					__index = function(self, key)
						-- stylua: ignore
						local ignore_proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
							cwd = key,
							text = true,
						})
						local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
							cwd = key,
							text = true,
						})
						local ret = {
							ignored = parse_output(ignore_proc),
							tracked = parse_output(tracked_proc),
						}

						rawset(self, key, ret)
						return ret
					end,
				})
			end
			local git_status = new_git_status()

			-- Clear git status cache on refresh
			local refresh = require("oil.actions").refresh
			local orig_refresh = refresh.callback
			refresh.callback = function(...)
				git_status = new_git_status()
				orig_refresh(...)
			end

			require("oil").setup({
				keymaps = {
					["gx"] = function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						local dir = oil.get_current_dir()

						if not entry or not dir then
							return
						end

						local filepath = dir .. entry.name

						if entry.name:match("%.zip$") then
							vim.fn.jobstart({ "unzip", filepath }, { detach = true })
							require("oil.actions").refresh.callback()
						else
							vim.ui.open(filepath)
						end
					end,
				},
				view_options = {
					show_hidden = true,

					---@diagnostic disable-next-line: unused-local
					highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
						if is_hidden then
							return "Comment"
						end
						return nil
					end,

					is_hidden_file = function(name, bufnr)
						local dir = require("oil").get_current_dir(bufnr)
						-- directory not created yet (avoid erroring on git_status[dir])
						if vim.fn.isdirectory(dir) == 0 then
							return false
						end
						local is_dotfile = vim.startswith(name, ".")
						-- if no local directory (e.g. for ssh connections), just hide dotfiles
						if not dir then
							return is_dotfile
						end
						-- dotfiles are considered hidden unless tracked
						if is_dotfile then
							return not git_status[dir].tracked[name]
						else
							-- Check if file is gitignored
							return git_status[dir].ignored[name]
						end
					end,
				},
				preview_win = {
					disable_preview = function(filename)
						if vim.fn.fnamemodify(filename, ":t") == ".env" then
							return true
						end

						return false
					end,
				},
				win_options = {
					signcolumn = "auto:2",
				},
			})

			-- open preview automatically at size
			vim.keymap.set({ "n", "v", "x" }, "<leader>e", function()
				local oil = require("oil")
				local util = require("oil.util")

				if string.sub(vim.api.nvim_buf_get_name(0), 1, 3) == "oil" then
					oil.close()
					return
				end

				local percent = 0.4

				oil.open(nil, nil, function()
					local oil_win = vim.api.nvim_get_current_win()
					local width = vim.api.nvim_win_get_width(oil_win)
					local height = vim.api.nvim_win_get_height(oil_win)

					oil.open_preview(nil, function()
						local preview_win = util.get_preview_win({ include_not_owned = true })
						if preview_win then
							vim.api.nvim_win_set_config(preview_win, {
								focusable = false,
								border = "none",
								width = math.floor(width * percent),
								relative = "win",
								win = oil_win,
								col = width - math.floor(width * percent),
								row = 0,
								height = height,
							})

							local group = vim.api.nvim_create_augroup("OilPreviewResize", { clear = true })
							vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
								group = group,
								callback = function()
									if not vim.api.nvim_win_is_valid(oil_win) or not vim.api.nvim_win_is_valid(preview_win) then
										return
									end
									local new_width = vim.api.nvim_win_get_width(oil_win)
									local new_height = vim.api.nvim_win_get_height(oil_win)

									vim.api.nvim_win_set_config(preview_win, {
										relative = "win",
										win = oil_win,
										width = math.floor(new_width * percent),
										col = new_width - math.floor(new_width * percent),
										row = 0,
										height = new_height,
									})
								end,
							})
						end
					end)
				end)
			end, { noremap = true, silent = true, desc = "Open File Explorer" })
		end,
	},
	{
		"twhlynch/oil-git.nvim",
		branch = "fix/status-spam", -- ill pr eventually im lazy
		dependencies = { "barrettruth/canola.nvim" },
		opts = {
			show_file_highlights = true,
			show_directory_highlights = true,
			show_ignored_files = true,
			show_ignored_directories = false,

			show_file_symbols = true,
			show_directory_symbols = true,
			symbol_position = "signcolumn",

			symbols = {
				file = {
					added = "┃",
					modified = "┃",
					renamed = "┆",
					deleted = "┆",
					copied = "┆",
					conflict = "⦚",
					untracked = "",
					ignored = "",
				},
				directory = {
					added = "┃",
					modified = "┃",
					renamed = "┆",
					deleted = "┆",
					copied = "┆",
					conflict = "⦚",
					untracked = "",
					ignored = "",
				},
			},

			highlight = {
				-- in ./theme.lua
			},
		},
	},
}
