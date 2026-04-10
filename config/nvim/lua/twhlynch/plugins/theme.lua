return {
	"vague2k/vague.nvim",
	config = function()
		for _, group in pairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
		require("vague").setup({
			transparent = true,
			bold = true,
			italic = true,
			colors = {
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
			},
			on_highlights = function(highlights, _)
				-- no visual fg override
				highlights.Visual.fg = nil
				-- no treesitter context bg
				highlights.TreesitterContext = nil
				-- highlights.TreesitterContextLineNumber.bg = nil
				-- no background on Pmenu
				highlights.Pmenu.bg = nil
				-- fix float border
				highlights.FloatBorder = { fg = "#878787" }
				-- blink cmp
				highlights.BlinkCmpMenuSelection = { fg = "#AEAED1", bg = "#252530" } -- selected item
				highlights.BlinkCmpLabel = { fg = "#cdcdcd" } -- item label
				highlights.BlinkCmpLabelMatch = { fg = "#f3be7c" } -- matching text
				highlights.BlinkCmpMenuBorder = { link = "FloatBorder" } -- border
				highlights.BlinkCmpKind = { fg = "#AEAED1" } -- item icon

				-- darken readonly methods
				highlights["@lsp.typemod.method.readonly.cpp"] = { fg = "#bb7070" }
				-- color functions
				-- highlights["@lsp.typemod.function"].fg = "#c48282"
				highlights["@lsp.type.function"].fg = "#c48282"
				highlights["@function.call"].fg = "#c48282"
				highlights["@function.method.call"].fg = "#c48282"
				-- color macros like functions
				highlights["@lsp.type.macro"].fg = "#c48282"
				-- python docs are comments
				highlights["@string.documentation.python"] = { fg = "#606079" }
				-- lua docs are darker
				highlights["@keyword.return.luadoc"] = { fg = "#507796" }
				highlights["@keyword.luadoc"] = { fg = "#507796" }
				highlights["@lsp.typemod.keyword.documentation.lua"] = { fg = "#507796" }
				-- lua macros are types
				highlights["@lsp.type.macro.lua"] = { fg = "#9bb4bc" }
				highlights["@function.macro.luadoc"] = { fg = "#9bb4bc" }
			end,
		})
		vim.cmd("colorscheme vague")
		vim.cmd(":hi BlinkCmpMenu guibg=NONE")
		vim.cmd(":hi statusline guibg=NONE")
	end,
}
