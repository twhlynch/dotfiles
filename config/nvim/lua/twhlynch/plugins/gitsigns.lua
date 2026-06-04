return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = {
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buf = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]h", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Next hunk", noremap = true })

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[h", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Previous hunk", noremap = true })

				map("n", "]H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]H", bang = true })
					else
						gitsigns.nav_hunk("next", { target = "all" })
					end
				end, { desc = "Next hunk (all)", noremap = true })

				map("n", "[H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[H", bang = true })
					else
						gitsigns.nav_hunk("prev", { target = "all" })
					end
				end, { desc = "Previous hunk (all)", noremap = true })

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk", noremap = true })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk", noremap = true })

				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk", noremap = true })

				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk", noremap = true })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff file", noremap = true })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk", noremap = true })

				map({ "n", "v" }, "<leader>ht", function()
					gitsigns.toggle_linehl()
					local state = gitsigns.toggle_numhl()
					print("gitsigns hl: " .. (state and "on" or "off"))
				end, { desc = "Toggle Diff Highlight", noremap = true })
			end,
		})
		require("scrollbar.handlers.gitsigns").setup()
	end,
	init = function()
		-- remove the + and - diff prefixes from each line
		-- based on gitsigns popup.lua partition_linesspec
		local function remove_diff_prefix(lines_spec)
			for _, section in ipairs(lines_spec) do
				for _, part in ipairs(section) do
					local text, hls = part[1], part[2]

					-- remove first character
					if string.match(text, "^[+-]") then
						part[1] = text:sub(2)

						-- update hls
						if type(hls) ~= "string" then
							for _, h in ipairs(hls) do
								h.start_col = math.max(h.start_col - 1, 0)
								h.end_col = math.max(h.end_col - 1, 0)
							end
						end
					end
				end
			end
		end

		-- removes the first line which is always 'Hunk N of M'
		-- assumes theres always content
		local function remove_first(lines_spec)
			local first_line = lines_spec[1][1][1]
			table.remove(lines_spec, 1)
			return first_line
		end

		-- fix default opts and add title
		local function set_win_opts(winid, title)
			vim.api.nvim_win_set_config(winid, {
				title = title,
				title_pos = "left",
			})
			vim.wo[winid].list = vim.wo[0].list
			vim.wo[winid].listchars = vim.wo[0].listchars
		end

		-- override create and update for hunk preview popups
		local popup = require("gitsigns.popup")

		local old_create = popup.create
		---@diagnostic disable-next-line: duplicate-set-field
		popup.create = function(lines_spec, opts, id)
			local first_line = remove_first(lines_spec)
			remove_diff_prefix(lines_spec)
			local winid, bufnr = old_create(lines_spec, opts, id)
			set_win_opts(winid, first_line)
			return winid, bufnr
		end

		local old_update = popup.update
		---@diagnostic disable-next-line: duplicate-set-field
		popup.update = function(winid, bufnr, lines_spec, opts)
			local first_line = remove_first(lines_spec)
			remove_diff_prefix(lines_spec)
			old_update(winid, bufnr, lines_spec, opts)
			set_win_opts(winid, first_line)
		end
	end,
}
