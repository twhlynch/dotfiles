return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- stylua: ignore start
				ensure_installed = {
					"vimdoc", "javascript", "typescript",
					"jsdoc", "tsx", "yaml", "html",
					"css", "markdown", "markdown_inline", "graphql",
					"bash", "vim", "dockerfile", "gitignore",
					"query", "c", "rust", "java",
					"go", "perl", "python", "ruby",
					"lua", "php", "dart", "cpp",
					"asm", "proto", "jsonc", "toml",
					"git_config", "gitattributes", "vue", "regex",
					"sql", "glsl", "c_sharp", "csv",
					"diff",
				},
				-- stylua: ignore end
				sync_install = false,
				auto_install = true,
				indent = { enable = false },
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 1 * 1024 * 1024 -- 1MB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							-- stylua: ignore
							vim.notify("File larger than 100KB treesitter disabled for performance", vim.log.levels.WARN, { title = "Treesitter" })
							return true
						end
					end,
					additional_vim_regex_highlighting = { "markdown" },
				},
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]o"] = "@loop.*",
							["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]M"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
						goto_next = {
							["]i"] = "@conditional.outer",
							["]C"] = { query = "@class.outer", desc = "Next class" },
						},
						goto_previous = {
							["[i"] = "@conditional.outer",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiwindow = false,
				max_lines = 10,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "topline",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})

			-- width - 1 to keep scrollbar visible
			local render = require("treesitter-context.render")
			local old_open = render.open
			render.open = function(main_winid, ...)
				old_open(main_winid, ...)

				local width = vim.api.nvim_win_get_width(main_winid)
				local gutter_width = vim.fn.getwininfo(main_winid)[1].textoff

				for _, winid in ipairs(vim.api.nvim_list_wins()) do
					if vim.w[winid] and vim.w[winid]["treesitter_context"] then
						vim.api.nvim_win_set_width(winid, width - gutter_width - 1)
					end
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		config = function()
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter.textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter.textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter.textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter.textobjects.select").select_textobject("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter.textobjects.select").select_textobject("@local.scope", "locals")
			end)
		end,
	},
}
