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

local lsp_log = vim.lsp.log.get_filename()
local max_lsp_log_size = 10 * 1024 * 1024

local stat = vim.uv.fs_stat(lsp_log)
if stat and stat.size > max_lsp_log_size then
	vim.uv.fs_open(lsp_log, "w", 420, function(err, fd)
		if not err and fd then
			vim.uv.fs_close(fd)
		end
	end)
end

vim.lsp.log.set_level(vim.log.levels.ERROR)
