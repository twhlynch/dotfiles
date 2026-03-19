local autocmd = vim.api.nvim_create_autocmd

local augroup = vim.api.nvim_create_augroup("CustomAutoCmds", { clear = true })

-- highlight when yanking text
autocmd({ "TextYankPost" }, {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- no scrolloff if buffer readonly
autocmd({ "BufWinEnter", "WinEnter" }, {
	group = augroup,
	callback = function()
		local ignore_scrolloff = --
			not vim.bo.modifiable -- not modifiable
			or vim.bo.readonly -- readonly
			or vim.bo.buftype == "nowrite" -- nowrite
			or vim.bo.buftype == "prompt" -- prompt

		if ignore_scrolloff then
			vim.opt_local.scrolloff = 0
		else
			vim.opt_local.scrolloff = vim.g.user_scrolloff or 8
		end
	end,
})

-- yankring
autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		if vim.v.event.operator == "y" then
			for i = 9, 1, -1 do -- shift all numbered registers
				vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
			end
		end
	end,
})
