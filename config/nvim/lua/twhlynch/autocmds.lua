-- highlight when yanking text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- no scrolloff if buffer readonly
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = vim.api.nvim_create_augroup("SetScrollOff", { clear = true }),
	callback = function()
		if vim.bo.buftype == "nowrite" or vim.bo.buftype == "prompt" or not vim.bo.modifiable or vim.bo.readonly then
			vim.opt_local.scrolloff = 0
		else
			vim.opt_local.scrolloff = vim.g.user_scrolloff or 8
		end
	end,
})
