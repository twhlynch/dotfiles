return {
	-- "twhlynch/tasks.nvim",
	dir = "~/Documents/Personal/tasks.nvim",
	opts = {
		sign_icon = "",
		keybind = "<leader><CR>",
		keybind_picker = "<leader>B",
		sign_hl = "DiagnosticFloatingOk",
		providers = { "vscode", "npm" },
		runner = function(cmd)
			-- first word only alpha
			local name = ((cmd:match("^[^%s]+") or ""):gsub("[^%a]", ""))

			vim.fn.system({
				"tmux",
				"kill-window",
				"-t",
				name,
				"2>/dev/null",
			})

			vim.fn.system({
				"tmux",
				"new-window",
				"-n",
				name,
				"-d",
				"$SHELL -i -c " .. vim.fn.shellescape(cmd .. "; echo; read"),
			})
		end,
	},
}
