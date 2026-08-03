---@type vim.lsp.Config
return {
	cmd = { "ltex-ls-plus" },
	filetypes = {
		"bib",
		"plaintex",
		"rst",
		"tex",
	},
	settings = {
		ltex = {
			enabled = {
				"bib",
				"plaintex",
				"rst",
				"tex",
				"latex",
			},
		},
	},
}
