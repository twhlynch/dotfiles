---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--suggest-missing-includes",
	},
	filetypes = {
		"c",
		"cpp",
		"h",
		"hpp",
		"cc",
		"objc",
		"objcpp",
		"cuda",
		"mm",
		"m",
		"cc",
		"hh",
	},
	root_markers = {
		"compile_commands.json",
		".git",
		".clangd",
	},
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
}
