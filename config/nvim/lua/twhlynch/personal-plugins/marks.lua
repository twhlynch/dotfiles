-- https://github.com/petertriho/nvim-scrollbar/discussions/65
local M = {}

function M.setup()
	require("scrollbar.handlers").register("marksmarks", function(bufnr)
		local out = {}

		local marks = vim.fn.getmarklist(bufnr)

		for _, mark in pairs(marks) do
			local symbol = mark.mark:sub(2, 2)
			local isLetter = symbol:lower() ~= symbol:upper()
			if isLetter and symbol ~= "z" then
				table.insert(out, {
					line = mark.pos[2],
					text = symbol,
					type = "Info",
					level = 6,
				})
			end
		end

		return out
	end)
end

return M
