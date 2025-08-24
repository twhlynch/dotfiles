-- scrollbar integration to show regions/marks in scrollbar
local M = {}

local options = {
	region_markers = {
		"MARK: ",
		"#region ",
	},
	debug = false,
}

function M.get_regions(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local regions = {}

	for i, line in ipairs(lines) do
		local is_region = false
		local mark_text = ""

		for _, pattern in ipairs(options.region_markers) do
			local loc = line:find(pattern)
			if loc ~= nil then
				is_region = true
				mark_text = vim.trim(line:sub(loc + #pattern, #line))
				break
			end
		end

		if is_region and mark_text ~= "-" then
			table.insert(regions, {
				line = i - 1,
				text = mark_text .. "─",
				type = "Info",
				level = 1,
				priority = 1,
			})
		end
	end

	return regions
end

function M.goto_next_region()
	local regions = M.get_regions(0)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	for i = 1, #regions do
		if regions[i].line > current_line then
			vim.api.nvim_win_set_cursor(0, { regions[i].line, 0 })
			break
		end
	end
end

function M.goto_prev_region()
	local regions = M.get_regions(0)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	for i = #regions, 1, -1 do
		if regions[i].line < current_line then
			vim.api.nvim_win_set_cursor(0, { regions[i].line, 0 })
			break
		end
	end
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	require("scrollbar.handlers").register("Regions", M.get_regions)
end

return M
