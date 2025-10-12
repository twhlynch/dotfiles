---@type vim.lsp.Config
return {
	cmd = {
		"bash-language-server",
		"start",
	},
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
	filetypes = { "zsh", "bash", "sh" },
	root_markers = { ".git", ".zshrc", ".bashrc" },
	single_file_support = true,
}
