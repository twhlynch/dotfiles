---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--header-insertion-decorators",
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
		".clang-tidy",
		".clang-format",
	},
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
}
