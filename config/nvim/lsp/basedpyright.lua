---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "off",
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}
