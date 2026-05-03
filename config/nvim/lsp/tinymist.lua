---@type vim.lsp.Config
return {
	cmd = {
		"tinymist",
	},
	filetypes = {
		"typst",
	},
	settings = {
		formatterMode = "enable",
		exportPdf = "onSave",
	},
}
