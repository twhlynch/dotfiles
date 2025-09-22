-- already in snacks :<
local U = require("twhlynch.personal-plugins.util")

local M = {}

local options = {
	blame_format = "%an, %ar - %B",
}

function M.format_picker(item, _)
	return {}
end

function M.display(blames)
	vim.cmd("botright new")
	vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local" })
	vim.api.nvim_set_option_value("bufhidden", "hide", { scope = "local" })
	vim.api.nvim_set_option_value("swapfile", false, { scope = "local" })
	vim.api.nvim_buf_set_lines(0, 0, -1, false, blames)
	vim.api.nvim_set_option_value("modifiable", false, { scope = "local" })

	-- local items = {}
	--
	-- for i, blame in ipairs(blames) do
	-- 	table.insert(items, {
	-- 		text = blame,
	-- 		file = nil,
	-- 		score = i,
	-- 	})
	-- end
	--
	-- local function finder(_, _)
	-- 	return items
	-- end
	--
	-- Snacks.picker({
	-- 	title = "Line Blames",
	-- 	finder = finder,
	-- 	on_close = nil,
	-- 	format = M.format_picker,
	-- 	live = false,
	-- })
end

function M.parse_blames(input)
	local lines = vim.fn.split(input, "\n")
	local blames = {}

	for _, line in ipairs(lines) do
		if #line >= 3 then -- should at least have ' - '
			table.insert(blames, line)
		end
	end

	return blames
end

function M.get_blames()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local filename = vim.fn.expand("%:.")

	-- TODO: visual selection
	local blameline = line .. "," .. line .. ":" .. filename
	local command = { "git", "log", "-L", blameline, '--pretty=format:"' .. options.blame_format .. '"', "--no-patch" }

	U.job_async(command, function(response)
		local blames = M.parse_blames(response)
		M.display(blames)
	end, function(error)
		vim.notify(error, vim.log.levels.ERROR)
	end)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M