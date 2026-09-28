return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters.cppcheck.args = {
			"--enable=all",
			function()
				return "--language=" .. (vim.bo.filetype == "cpp" and "c++" or "c")
			end,
			"--inline-suppr",
			"--suppress=variableScope",
			"--check-level=exhaustive",
			"--quiet",
			function()
				if vim.fn.isdirectory(".cache/cppcheck") ~= 1 then
					vim.fn.mkdir(".cache/cppcheck", "p")
				end
				return "--cppcheck-build-dir=.cache/cppcheck"
			end,
			"--template={file}:{line}:{column}: [{id}] {severity}: {message}",
		}

		lint.linters_by_ft = {
			cpp = { "cppcheck" },
			c = { "cppcheck" },
		}

		local augroup = vim.api.nvim_create_augroup("nvim_lint_update", { clear = true })
		local enabled = false

		local function toggle_on()
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
				group = augroup,
				callback = lint.try_lint,
			})

			lint.try_lint()
		end
		local function toggle_off()
			vim.api.nvim_clear_autocmds({ group = augroup })
			local ns = lint.get_namespace("cppcheck")
			vim.diagnostic.reset(ns, 0)
		end

		vim.keymap.set("n", "<leader>ll", function()
			enabled = not enabled
			local _ = enabled and toggle_on() or toggle_off()
		end, { desc = "Toggle linting" })
	end,
}
