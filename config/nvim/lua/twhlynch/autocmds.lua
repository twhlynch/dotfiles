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

-- textwidth only for 'writing'
autocmd({ "FileType" }, {
	group = augroup,
	pattern = { "text", "markdown", "typst", "tex" },
	callback = function()
		vim.opt_local.textwidth = 80
	end,
})

-- chmod +x for shell files on creation
local shell_pattern = "*/{*.sh,*.zsh}"

autocmd("BufNewFile", {
	group = augroup,
	pattern = shell_pattern,
	callback = function(args)
		vim.b[args.buf]._chmod_x = true
	end,
})

autocmd("BufWritePost", {
	group = augroup,
	pattern = shell_pattern,
	callback = function(args)
		if vim.b[args.buf]._chmod_x then
			vim.b[args.buf]._chmod_x = nil
			vim.fn.system("chmod +x " .. vim.fn.shellescape(args.match))
		end
	end,
})

autocmd("User", {
	group = augroup,
	pattern = "OilActionsPost",
	callback = function(args)
		for _, action in ipairs(args.data.actions) do
			if action.entry_type == "file" and action.type == "create" then
				local path = action.url:gsub("^oil://", "")
				if path:match("%.z?sh$") then
					vim.fn.system("chmod +x " .. vim.fn.shellescape(path))
				end
			end
		end
	end,
})
