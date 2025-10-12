---@type vim.lsp.Config
return {
	cmd = { "ltex-ls-plus" },
	filetypes = {
		"bib",
		"plaintex",
		"rst",
		"tex",
		"typst",
	},
	root_markers = { ".git" },
	get_language_id = function(_, filetype)
		return ({
			bib = "bibtex",
			plaintex = "tex",
			rst = "restructuredtext",
			tex = "latex",
		})[filetype] or filetype
	end,
	settings = {
		ltex = {
			enabled = {
				"bib",
				"plaintex",
				"rst",
				"tex",
				"latex",
				"typst",
			},
		},
	},
}
