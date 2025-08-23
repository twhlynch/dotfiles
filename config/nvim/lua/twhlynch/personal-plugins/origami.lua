-- h adn l to open close folds from chrisgrieser/nvim-origami
local M = {}

local options = {
	debug = false,
}

function M.normal(cmdStr)
	vim.cmd.normal({ cmdStr, bang = true })
end

-- `h` closes folds when at the beginning of a line.
function M.h()
	-- saved as `normal` affects it
	local count = vim.v.count1
	for _ = 1, count, 1 do
		local col = vim.api.nvim_win_get_cursor(0)[2]
		if col == 0 then
			local wasFolded = pcall(M.normal, "zc")
			if not wasFolded then
				M.normal("h")
			end
		else
			M.normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
function M.l()
	-- saved as `normal` affects it
	local count = vim.v.count1
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1
		local action = isOnFold and "zo" or "l"
		pcall(M.normal, action)
	end
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	vim.keymap.set({ "n" }, "h", M.h, { noremap = true, silent = true, desc = "Origami h" })
	vim.keymap.set({ "n" }, "l", M.l, { noremap = true, silent = true, desc = "Origami l" })
end

return M
