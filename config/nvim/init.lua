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

require("twhlynch")
vim.lsp.log.set_level(vim.log.levels.ERROR)
