-- jump pair from sylvianfranklin/pear
local M = {}

local options = {
	source_exts = {},
	header_exts = {},
	debug = false,
}

function M.jump_pair()
	local ext = vim.fn.expand("%:e")

	local target_exts = nil
	if vim.tbl_contains(options.header_exts, ext) then
		target_exts = options.source_exts
	elseif vim.tbl_contains(options.source_exts, ext) then
		target_exts = options.header_exts
	else
		print("Not a recognized file pair.")
		return
	end

	local base_name = vim.fn.expand("%:r")
	for _, target_ext in ipairs(target_exts) do
		local target_file = base_name .. "." .. target_ext
		if vim.fn.filereadable(target_file) == 1 then
			vim.cmd("edit " .. target_file)
			return
		end
	end

	print("Corresponding file not found.")
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M
