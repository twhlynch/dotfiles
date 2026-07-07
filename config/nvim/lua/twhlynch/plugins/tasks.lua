return {
	-- "twhlynch/tasks.nvim",
	dir = "~/Documents/Personal/tasks.nvim",
	opts = {
		sign_icon = "",
		keybind = "<leader><CR>",
		keybind_picker = "<leader>B",
		sign_hl = "DiagnosticFloatingOk",
		providers = { "vscode", "npm" },
		ignore = { "%.git/", "[vV]endor/", "third[-_]party/" },
	},
}
