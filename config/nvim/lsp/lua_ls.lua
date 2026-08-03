---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			diagnostics = {
				disable = { "missing-parameters", "missing-fields" },
			},
		},
	},
}
