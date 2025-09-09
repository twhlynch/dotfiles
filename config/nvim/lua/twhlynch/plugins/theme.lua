return {
	"vague2k/vague.nvim",
	config = function()
		require("vague").setup({
			transparent = true,
			on_highlights = function(highlights, colors)
				highlights.Visual.fg = nil
				highlights.TreesitterContext = nil
				highlights.TreesitterContextLineNumber.bg = nil

				highlights["@lsp.typemod.method.readonly.cpp"] = {
					fg = "#bb7070",
				}
			end,
		})
		vim.cmd("colorscheme vague")
		vim.cmd(":hi statusline guibg=NONE")
	end,
}
