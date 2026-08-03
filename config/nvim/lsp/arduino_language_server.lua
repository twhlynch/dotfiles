---@type vim.lsp.Config
return {
	cmd = {
		"arduino-language-server",
		"-cli-config",
		os.getenv("HOME") .. "/Library/Arduino15/arduino-cli.yaml",
		"--fqbn",
		"arduino:avr:uno",
	},
}
