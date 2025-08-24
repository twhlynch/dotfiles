-- plugin template
local M = {}

local options = {}

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M
