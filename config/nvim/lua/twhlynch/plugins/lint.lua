return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		table.insert(lint.linters.cppcheck.args, "--check-level=exhaustive")

		lint.linters_by_ft = {
			cpp = { "cppcheck" },
			c = { "cppcheck" },
		}

		-- run on save and on entering a buffer
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			group = vim.api.nvim_create_augroup("nvim_lint_update", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
