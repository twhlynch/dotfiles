return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"jsdoc",
					"tsx",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"graphql",
					"bash",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"c",
					"rust",
					"java",
					"go",
					"perl",
					"python",
					"ruby",
					"lua",
					"php",
					"dart",
					"cpp",
					"asm",
					"proto",
					"jsonc",
					"toml",
					"git_config",
					"gitattributes",
					"vue",
					"regex",
					"sql",
					"glsl",
					"c_sharp",
					"csv",
					"diff",
				},
				sync_install = false,
				auto_install = true,
				indent = { enable = false },
				highlight = {
					enable = true,
					disable = function(lang, buf)
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
			})

			-- local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			-- treesitter_parser_config.language = {
			-- 	install_info = {
			-- 		url = "https://github.com/user/tree-sitter-language.git",
			-- 		files = { "src/parser.c", "src/scanner.c" },
			-- 		branch = "main",
			-- 	},
			-- }
			--
			-- vim.treesitter.language.register("language", "language")
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
}
