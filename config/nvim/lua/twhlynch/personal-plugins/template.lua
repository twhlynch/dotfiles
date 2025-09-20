-- plugin template
local U = require("twhlynch.personal-plugins.util")

local M = {}

local options = {}

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M