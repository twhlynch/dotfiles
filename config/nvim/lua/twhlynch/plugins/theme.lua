return {
	{
		"vague2k/vague.nvim",
		config = function()
			local c = {
				bg = "#141415",
				inactiveBg = "#1c1c24",
				fg = "#cdcdcd",
				floatBorder = "#878787",
				line = "#252530",
				comment = "#606079",
				builtin = "#b4d4cf",
				func = "#c48282",
				string = "#e8b589",
				number = "#e0a363",
				property = "#c3c3d5",
				constant = "#aeaed1",
				parameter = "#bb9dbd",
				visual = "#333738",
				error = "#d8647e",
				warning = "#f3be7c",
				hint = "#7e98e8",
				operator = "#90a0b5",
				keyword = "#6e94b2",
				type = "#9bb4bc",
				search = "#405065",
				plus = "#7fa563",
				delta = "#f3be7c",

				func_darker = "#bb7070",
				keyword_darker = "#507796",
				conflict = "#faa387",
				red = "#ff0000",
			}

			for _, group in pairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end

			require("vague").setup({
				transparent = true,
				bold = true,
				italic = true,
				colors = c,
				on_highlights = function(highlights, _)
					-- no visual fg override
					highlights.Visual.fg = nil
					-- no treesitter context bg
					highlights.TreesitterContext = nil
					-- highlights.TreesitterContextLineNumber.bg = nil
					-- no background on Pmenu
					highlights.Pmenu.bg = nil
					-- fix float border
					highlights.FloatBorder = { fg = c.floatBorder }
					-- blink cmp
					highlights.BlinkCmpMenuSelection = { fg = c.constant, bg = c.line } -- selected item
					highlights.BlinkCmpLabel = { fg = c.fg } -- item label
					highlights.BlinkCmpLabelMatch = { fg = c.delta } -- matching text
					highlights.BlinkCmpMenuBorder = { link = "FloatBorder" } -- border
					highlights.BlinkCmpKind = { fg = c.constant } -- item icon
					-- errors
					highlights.Error = { fg = c.error }
					highlights.NvimInternalError = { fg = c.warning, bg = c.red }

					-- oil git
					highlights.OilGitModifiedStaged = { fg = c.delta }
					highlights.OilGitModifiedUnstaged = { fg = c.number }
					highlights.OilGitRenamed = { fg = c.hint }
					highlights.OilGitDeleted = { fg = c.error }
					highlights.OilGitCopied = { fg = c.hint }
					highlights.OilGitConflict = { fg = c.conflict }
					highlights.OilGitUntracked = { fg = c.plus }
					highlights.OilGitAdded = { fg = c.plus }
					highlights.OilGitIgnored = { fg = c.comment }

					-- icons
					highlights.MiniIconsAzure = { fg = c.keyword }
					highlights.MiniIconsBlue = { fg = c.hint }
					highlights.MiniIconsCyan = { fg = c.property }
					highlights.MiniIconsGreen = { fg = c.plus }
					highlights.MiniIconsGrey = { fg = c.floatBorder }
					highlights.MiniIconsOrange = { fg = c.conflict }
					highlights.MiniIconsPurple = { fg = c.parameter }
					highlights.MiniIconsRed = { fg = c.func }
					highlights.MiniIconsYellow = { fg = c.delta }

					-- delimiters as operators
					highlights["Delimiter"] = { link = "Operator" }
					-- variable
					highlights["@variable"] = { link = "Constant" }
					-- darken readonly methods
					highlights["@lsp.typemod.method.readonly.cpp"] = { fg = c.func_darker }
					-- color functions
					-- highlights["@lsp.typemod.function"].fg = c.func
					highlights["@lsp.type.function"].fg = c.func
					highlights["@function.call"].fg = c.func
					highlights["@function.method.call"].fg = c.func
					-- color macros like functions
					highlights["@lsp.type.macro"].fg = c.func
					-- python docs are comments
					highlights["@string.documentation.python"] = { fg = c.comment }
					-- lua docs are darker
					highlights["@keyword.return.luadoc"] = { fg = c.keyword_darker }
					highlights["@keyword.luadoc"] = { fg = c.keyword_darker }
					highlights["@lsp.typemod.keyword.documentation.lua"] = { fg = c.keyword_darker }
					-- lua macros are types
					highlights["@lsp.type.macro.lua"] = { fg = c.type }
					highlights["@function.macro.luadoc"] = { fg = c.type }
				end,
			})
			vim.cmd("colorscheme vague")
			vim.cmd(":hi BlinkCmpMenu guibg=NONE")
			vim.cmd(":hi statusline guibg=NONE")
		end,
	},
	-- use devicons first then mini icons for fallbacks and folders
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.icons",
		dependecies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local extensions = {}
			local files = {}
			local devicons = require("nvim-web-devicons")

			local seen = {}
			local get_hl = function(hex)
				local hl = "ColorOverride_" .. hex:sub(2)
				if not seen[hex] then
					vim.api.nvim_set_hl(0, hl, { fg = hex })
					seen[hex] = true
				end
				return hl
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("ColorOverride", { clear = true }),
				callback = function()
					for color, _ in pairs(seen) do
						vim.api.nvim_set_hl(0, "ColorOverride_" .. color:sub(2), { fg = color })
					end
				end,
			})

			for ext, info in pairs(devicons.get_icons_by_extension()) do
				extensions[ext] = { glyph = info.icon, hl = get_hl(info.color) }
			end

			for name, info in pairs(devicons.get_icons_by_filename()) do
				files[name] = { glyph = info.icon, hl = get_hl(info.color) }
			end

			-- mini checks case
			files["README.md"] = vim.deepcopy(files["readme.md"])
			files[".DS_Store"] = vim.deepcopy(files[".ds_store"])

			require("mini.icons").setup({
				style = "glyph",
				default = {},
				directory = {},
				extension = extensions,
				file = files,
				filetype = {},
				lsp = {},
				os = {},
			})
			MiniIcons.mock_nvim_web_devicons()
		end,
	},
}
