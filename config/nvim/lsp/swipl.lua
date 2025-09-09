return {
	cmd = {
		"swipl",
		"-g",
		"use_module(library(lsp_server)).",
		"-g",
		"lsp_server:main",
		"-t",
		"halt",
		"--",
		"stdio",
	},
	filetypes = {
		"prolog",
	},
	root_markers = {
		"*.pl",
	},
}
