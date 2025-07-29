local lib = {}

-- h l to open close folds from chrisgrieser/nvim-origami

local function normal(cmdStr)
	vim.cmd.normal({ cmdStr, bang = true })
end

-- `h` closes folds when at the beginning of a line.
function lib.h()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local col = vim.api.nvim_win_get_cursor(0)[2]
		if col == 0 then
			local wasFolded = pcall(normal, "zc")
			if not wasFolded then
				normal("h")
			end
		else
			normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
function lib.l()
	local count = vim.v.count1 -- count needs to be saved due to `normal` affecting it
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1
		local action = isOnFold and "zo" or "l"
		pcall(normal, action)
	end
end

-- jump pair from sylvianfranklin/pear

function lib.jump_pair()
	local ext = vim.fn.expand("%:e")

	local source_exts = { "c", "cpp", "frag" }
	local header_exts = { "h", "hpp", "vert" }

	local target_exts = nil
	if vim.tbl_contains(header_exts, ext) then
		target_exts = source_exts
	elseif vim.tbl_contains(source_exts, ext) then
		target_exts = header_exts
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
	require("oil").open()
end

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

-- vscode like surround in visual mode

local function surround(pref, suf, trigger)
	vim.keymap.set({ "v" }, "s" .. trigger, "<esc>`<i" .. pref .. "<esc>`>la" .. suf .. "<esc>gvll", desc("Surround with " .. pref .. " " .. suf))
end

function lib.setup_surround(table)
	for _, v in ipairs(table) do
		local pref, suf, trig1, trig2 = v[1], v[2], v[3], v[4]
		local p, s = pref:sub(1, 1), suf:sub(1, 1)

		if trig1 ~= nil then
			surround(pref, suf, trig1)
		end
		if trig2 ~= nil then
			surround(pref, suf, trig2)
		end

		surround(pref, suf, p)
		if p ~= s then
			surround(pref, suf, s)
		end
	end
end

return lib
