if vim.env.PROF then
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter",
			-- event = "UIEnter",
			-- event = "VeryLazy",
		},
	})
end

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

require("twhlynch")
vim.lsp.log.set_level(vim.log.levels.ERROR)
