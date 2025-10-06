-- plugin template
local U = require("twhlynch.personal-plugins.util")

local M = {}

local options = {}

local ns = vim.api.nvim_create_namespace("GitBlameView")

function M.time_ago(timestamp)
	local current_time = os.time()
	local diff = current_time - timestamp

	if diff < 1 then
		return "just now"
	end

	local seconds = diff
	local minutes = math.floor(seconds / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	local years = math.floor(days / 365.25)
	local months = 0

	if years == 0 then
		months = math.floor(days / 30.44)
	end

	if years >= 1 then
		return years .. (years == 1 and " year" or " years")
	elseif months >= 1 then
		return months .. (months == 1 and " month" or " months")
	elseif days >= 1 then
		return days .. (days == 1 and " day" or " days")
	elseif hours >= 1 then
		return hours .. (hours == 1 and " hour" or " hours")
	elseif minutes >= 1 then
		return minutes .. (minutes == 1 and " minute" or " minutes")
	else
		return seconds .. (seconds == 1 and " second" or " seconds")
	end
end

function M.hsl_to_hex(h, s, l)
	h = h / 360
	s = s / 100
	l = l / 100

	local c = (1 - math.abs(2 * l - 1)) * s
	local x = c * (1 - math.abs((h * 6) % 2 - 1))
	local m = l - c / 2
	local r, g, b = 0, 0, 0

	if 0 <= h and h < 1 / 6 then
		r, g, b = c, x, 0
	elseif 1 / 6 <= h and h < 2 / 6 then
		r, g, b = x, c, 0
	elseif 2 / 6 <= h and h < 3 / 6 then
		r, g, b = 0, c, x
	elseif 3 / 6 <= h and h < 4 / 6 then
		r, g, b = 0, x, c
	elseif 4 / 6 <= h and h < 5 / 6 then
		r, g, b = x, 0, c
	elseif 5 / 6 <= h and h < 1 then
		r, g, b = c, 0, x
	end

	r = math.floor((r + m) * 255)
	g = math.floor((g + m) * 255)
	b = math.floor((b + m) * 255)

	return string.format("#%02x%02x%02x", r, g, b)
end

-- function M.get_color(hash)
-- 	math.randomseed(hash:byte(1) + hash:byte(2) + hash:byte(3) + hash:byte(4))
-- 	local hue = math.random(120, 210) -- blue/green hue
-- 	local saturation = math.random(30, 60) -- low saturation
-- 	local lightness = math.random(10, 20) -- low lightness
--
-- 	local hex_color = M.hsl_to_hex(hue, saturation, lightness)
-- 	local group_name = "GitHashHighlight_" .. hash
-- 	vim.api.nvim_set_hl(0, group_name, { bg = hex_color })
--
-- 	return group_name
-- end
function M.get_color(timestamp)
	local current_time = os.time()
	local seconds = current_time - timestamp
	local minutes = math.floor(seconds / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	local hue = math.min(days, 90) + 130
	local saturation = math.min(days, 30) + 10

	local hex_color = M.hsl_to_hex(hue, saturation, 12)
	local group_name = "GitHashHighlight_" .. timestamp
	vim.api.nvim_set_hl(0, group_name, { bg = hex_color })

	return group_name
end

function M.get_blame_map(filepath)
	local cmd = string.format("git blame --line-porcelain %s", vim.fn.shellescape(filepath))
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local blame_map = {}
	local blame_colors = {}

	local entry = nil

	for line in handle:lines() do
		if string.sub(line, 1, 1) == "\t" then -- content
			-- pass
		elseif line == "boundary" or string.match(line, "^([^ ]+)") == "previous" then
			if entry ~= nil then
				if not blame_colors[entry.timestamp] then
					blame_colors[entry.timestamp] = M.get_color(entry.timestamp)
				end

				entry.color = blame_colors[entry.timestamp]

				entry.committed = (entry.hash ~= "0000000")
				if not entry.committed then
					entry.message = "New Changes"
				end

				table.insert(blame_map, entry)
			end
			entry = nil
		elseif string.match(line, "^([^ ]+)") == "filename" then
			-- pass
		elseif entry == nil then -- hash
			entry = { hash = string.sub(line, 1, 7) }
		else -- info
			local key = string.match(line, "^([^ ]+) ")
			local value = string.match(line, "^[^ ]+ (.*)")

			if key == "author" then
				entry.author = value
			elseif key == "author-time" then
				entry.timestamp = tonumber(value)
				entry.time = M.time_ago(entry.timestamp)
			elseif key == "summary" then
				entry.message = value
			end
		end
	end

	handle:close()
	return blame_map
end

local active_blames = {}
function M.show_blame()
	local content_buf = vim.api.nvim_get_current_buf()
	local content_win = vim.api.nvim_get_current_win()

	if active_blames[content_buf] ~= nil then
		if vim.api.nvim_win_is_valid(active_blames[content_buf]) then
			vim.api.nvim_win_close(active_blames[content_buf], true)
		end
		active_blames[content_buf] = nil
		return
	end

	local width = vim.api.nvim_win_get_width(content_win)

	vim.cmd("topleft vsplit")
	local blame_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_width(blame_win, math.floor(width * 0.3))
	local blame_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(blame_win, blame_buf)

	vim.api.nvim_set_option_value("buftype", "nofile", { buf = blame_buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = blame_buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = blame_buf })
	vim.api.nvim_set_option_value("number", false, { win = blame_win })
	vim.api.nvim_set_option_value("relativenumber", false, { win = blame_win })
	vim.api.nvim_set_option_value("signcolumn", "no", { win = blame_win })
	vim.api.nvim_set_option_value("listchars", "", { win = blame_win })
	vim.api.nvim_set_option_value("list", false, { win = blame_win })
	vim.api.nvim_set_option_value("scrolloff", vim.opt.scrolloff._value, { win = blame_win })

	vim.api.nvim_set_current_win(content_win)

	local filename = vim.api.nvim_buf_get_name(0)
	local blame_map = M.get_blame_map(filename)

	if blame_map then
		local formatted = {}
		for i, entry in ipairs(blame_map) do
			local formatted_line = ""
			if i == 1 or blame_map[i - 1].hash ~= entry.hash then
				-- formatted_line = string.format("%s %s, %s - %s", entry.hash, entry.author, entry.time, entry.message)
				formatted_line = string.format("%s, %s (%s)", entry.message, entry.author, entry.time)
			end
			table.insert(formatted, formatted_line)
		end
		vim.api.nvim_buf_set_lines(blame_buf, 0, -1, false, formatted)
		for i, entry in ipairs(blame_map) do
			if i == 1 or blame_map[i - 1].hash ~= entry.hash then
				vim.api.nvim_buf_set_extmark(blame_buf, ns, i - 1, #entry.message + #entry.author + 3, {
					hl_group = "Comment",
					end_line = i - 1,
					end_col = #entry.message + #entry.author + #entry.time + 5,
				})
				vim.api.nvim_buf_set_extmark(blame_buf, ns, i - 1, 0, {
					hl_group = "Added",
					end_line = i - 1,
					end_col = #entry.message,
				})
			end
			vim.api.nvim_buf_set_extmark(blame_buf, ns, i - 1, 0, {
				line_hl_group = entry.color,
			})
			vim.api.nvim_buf_set_extmark(content_buf, ns, i - 1, 0, {
				line_hl_group = entry.color,
				number_hl_group = entry.color,
				sign_hl_group = entry.color,
			})
		end
	end

	vim.api.nvim_set_option_value("modifiable", false, { buf = blame_buf })
	vim.api.nvim_set_option_value("readonly", true, { buf = blame_buf })

	-- fix weird scrolloff offset bug?
	vim.api.nvim_set_current_win(blame_win)
	vim.api.nvim_set_current_win(content_win)

	local function sync_scroll(src_win, dst_win)
		if not vim.api.nvim_win_is_valid(src_win) or not vim.api.nvim_win_is_valid(dst_win) then
			return
		end
		local topline = vim.fn.line("w0", src_win)
		vim.api.nvim_win_call(dst_win, function()
			vim.cmd("normal! " .. topline .. "zt")
		end)
	end

	local augroup = vim.api.nvim_create_augroup("BlameSync", { clear = false })
	vim.api.nvim_create_autocmd("WinScrolled", {
		group = augroup,
		callback = function(e)
			if e.buf == content_buf and vim.api.nvim_get_current_win() == content_win then
				sync_scroll(content_win, blame_win)
			elseif e.buf == blame_buf and vim.api.nvim_get_current_win() == blame_win then
				sync_scroll(blame_win, content_win)
			end
		end,
	})

	-- cleanup
	vim.api.nvim_create_autocmd("WinClosed", {
		group = augroup,
		callback = function(e)
			if e.buf == blame_buf or tonumber(e.match) == blame_win then
				pcall(vim.api.nvim_del_augroup_by_id, augroup)
				vim.api.nvim_buf_clear_namespace(content_buf, ns, 0, -1)
				active_blames[content_buf] = nil
			elseif e.buf == content_buf or tonumber(e.match) == content_win then
				if vim.api.nvim_win_is_valid(blame_win) then
					vim.api.nvim_win_close(blame_win, true)
				end
				pcall(vim.api.nvim_del_augroup_by_id, augroup)
				vim.api.nvim_buf_clear_namespace(content_buf, ns, 0, -1)
				active_blames[content_buf] = nil
			end
		end,
	})

	active_blames[content_buf] = blame_win
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M
