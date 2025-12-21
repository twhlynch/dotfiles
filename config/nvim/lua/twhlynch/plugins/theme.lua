return {
	"vague2k/vague.nvim",
	config = function()
		for _, group in pairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
		require("vague").setup({
			transparent = true,
			on_highlights = function(highlights, colors)
				highlights.Visual.fg = nil
				highlights.TreesitterContext = nil
				highlights.TreesitterContextLineNumber.bg = nil

				highlights["@lsp.typemod.method.readonly.cpp"] = {
					fg = "#bb7070",
				}
				highlights["@lsp.typemod.function"].fg = "#c48282"
				highlights["@lsp.type.function"].fg = "#c48282"
				highlights["@function.call"].fg = "#c48282"
				highlights["@function.method.call"].fg = "#c48282"
			end,
		})
		vim.cmd("colorscheme vague")
		vim.cmd(":hi BlinkCmpMenu guibg=NONE")
		vim.cmd(":hi statusline guibg=NONE")
	end,
}

--   bg = "#141415",
--   builtin = "#b4d4cf",
--   comment = "#606079",
--   constant = "#aeaed1",
--   delta = "#f3be7c",
--   error = "#d8647e",
--   fg = "#cdcdcd",
--   floatBorder = "#878787",
--   func = "#c48282",
--   hint = "#7e98e8",
--   inactiveBg = "#1c1c24",
--   keyword = "#6e94b2",
--   line = "#252530",
--   number = "#e0a363",
--   operator = "#90a0b5",
--   parameter = "#bb9dbd",
--   plus = "#7fa563",
--   property = "#c3c3d5",
--   search = "#405065",
--   string = "#e8b589",
--   type = "#9bb4bc",
--   visual = "#333738",
--   warning = "#f3be7c"
