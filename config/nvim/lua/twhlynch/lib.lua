local lib = {}

-- toggle wrap from dxrcy

function lib.toggle_wrap()
	if vim.wo.wrap then
		vim.wo.wrap = false
		print("Line wrapping is OFF")
	else
		vim.wo.wrap = true
		print("Line wrapping is ON")
	end
end

function lib.format()
	require("conform").format()
	print("Formatted")
end

function lib.open_oil()
	if string.sub(vim.api.nvim_buf_get_name(0), 1, 3) == "oil" then
		pcall(vim.api.nvim_command, "bprevious")
		return
	end
	require("oil").open(nil, nil, function()
		local width = vim.api.nvim_win_get_width(0)
		require("oil").open_preview(nil, function()
			vim.api.nvim_command("vertical resize" .. width * 0.7)
		end)
	end)
end

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

-- vscode like surround in visual mode

local function surround(pref, suf, trigger)
	local mov_right = string.rep("l", #pref)
	local adjust_selection = string.rep("l", #pref + #suf)
	vim.keymap.set({ "v" }, "s" .. trigger, "<esc>`<i" .. pref .. "<esc>`>" .. mov_right .. "a" .. suf .. "<esc>gv" .. adjust_selection, desc("Surround with " .. pref .. " " .. suf))
end

function lib.setup_surround(tbl)
	for _, surr in ipairs(tbl) do
		local pref = table.remove(surr, 1)
		local suf = table.remove(surr, 1)

		for _, trigger in ipairs(surr) do
			surround(pref, suf, trigger)
		end

		if #surr == 0 then
			local p, s = pref:sub(1, 1), suf:sub(1, 1)
			surround(pref, suf, p)
			if p ~= s then
				surround(pref, suf, s)
			end
		end
	end
end

return lib
