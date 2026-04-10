return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			-- stylua: ignore
			local parsers = {
				"vimdoc", "javascript", "typescript", "jsdoc", "tsx", "yaml", "html", "css", "markdown", "markdown_inline",
				"graphql", "bash", "vim", "dockerfile", "gitignore", "query", "c", "rust", "java", "go",
				"perl", "python", "ruby", "lua", "php", "dart", "cpp", "asm", "proto", "toml",
				"git_config", "gitattributes", "vue", "regex", "sql", "glsl", "c_sharp", "csv", "diff",
			}

			-- ensure parsers are installed
			require("nvim-treesitter").install(parsers)

			-- custom override register
			vim.treesitter.language.register("asm", "gasm")
			vim.treesitter.language.register("json", "jsonc")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
				callback = function(args)
					local parser = vim.treesitter.get_parser(args.buf)

					if not parser then
						return
					end

					-- max file size check
					local max_filesize = 1 * 1024 * 1024 -- 1MB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and (stats.size > max_filesize and vim.bo[args.buf].filetype ~= "python") then
						vim.notify("File larger than 1MB treesitter disabled for performance", vim.log.levels.WARN, { title = "Treesitter" })
						return
					end

					-- Start native treesitter highlighting
					vim.treesitter.start(args.buf)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
			---@diagnostic disable-next-line: duplicate-set-field
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
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			-- stylua: ignore start
			vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope", "locals") end)

			vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]o", function() move.goto_next_start("@loop.*", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end, { desc = "Next scope" })
			vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end, { desc = "Next fold" })

			vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)

			vim.keymap.set({ "n", "x", "o" }, "]i", function() move.goto_next("@conditional.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next("@class.outer", "textobjects") end, { desc = "Next class" })
			vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous("@conditional.outer", "textobjects") end)
			-- stylua: ignore end
		end,
	},
}
