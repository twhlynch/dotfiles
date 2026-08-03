---@type vim.lsp.Config
return {
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.zsh|.command)",
		},
	},
	filetypes = { "zsh", "bash", "sh" },
	single_file_support = true,
}
