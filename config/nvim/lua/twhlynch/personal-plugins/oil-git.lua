-- less bad rewrite of https://github.com/benomahony/oil-git.nvim
local U = require("twhlynch.personal-plugins.util")

local M = {}

local git_status = {}

local options = {
	highlight = {
		OilGitAdded = { fg = "#7fa563" },
		OilGitModified = { fg = "#f3be7c" },
		OilGitDeleted = { fg = "#d8647e" },
		OilGitRenamed = { fg = "#cba6f7" },
		OilGitUntracked = { fg = "#c48282" },
	},
	debug = false,
}

function M.debug(str)
	if options.debug then
		vim.notify("Debug: " .. str, vim.log.levels.INFO)
	end
end

function M.update_git_status()
	local oil = require("oil")
	local current_dir = oil.get_current_dir()

	if not current_dir then
		current_dir = vim.api.nvim_buf_get_name(0)
	end

	if not current_dir or current_dir == "" then
		return
	end

	local git_dir = vim.fn.finddir(".git", current_dir .. ";")
	if git_dir == "" then
		return
	end

	local git_root = vim.fn.fnamemodify(git_dir, ":p:h:h")

	M.debug("Update git status")
	U.job_async({ "git", "-C", git_root, "status", "--porcelain" }, function(status)
		git_status = M.parse_git_status(status, git_root)

		M.apply_git_highlights()
	end, M.debug)
end

function M.parse_git_status(output, git_root)
	local status = {}

	for line in output:gmatch("[^\r\n]+") do
		if #line >= 3 then
			local status_code = line:sub(1, 2)
			local filepath = line:sub(4)

			-- handle renames (format: "old-name -> new-name")
			if status_code:sub(1, 1) == "R" then
				local arrow_pos = filepath:find(" %-> ")
				if arrow_pos then
					filepath = filepath:sub(arrow_pos + 4)
				end
			end

			-- remove leading "./" if present
			if filepath:sub(1, 2) == "./" then
				filepath = filepath:sub(3)
			end

			local abs_path = git_root .. "/" .. filepath

			status[abs_path] = M.get_highlight_group(status_code)
		end
	end

	return status
end

function M.get_highlight_group(status_code)
	if not status_code then
		return nil
	end

	local first_char = status_code:sub(1, 1)
	local second_char = status_code:sub(2, 2)

	if first_char == "A" then
		return "OilGitAdded"
	elseif first_char == "M" then
		return "OilGitModified"
	elseif first_char == "R" then
		return "OilGitRenamed"
	elseif second_char == "M" then
		return "OilGitModified"
	elseif status_code == "??" then
		return "OilGitUntracked"
	end

	return nil
end

function M.clear_highlights()
	if vim.bo.filetype ~= "oil" then
		return
	end

	for name, _ in pairs(options.highlight) do
		vim.fn.clearmatches() -- FIXME: why does this loop?
	end
end

function M.apply_git_highlights()
	if vim.bo.filetype ~= "oil" then
		return
	end

	local oil = require("oil")
	local current_dir = oil.get_current_dir()

	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	M.clear_highlights()

	for i, line in ipairs(lines) do
		local entry = oil.get_entry_on_line(bufnr, i)
		if entry and entry.type == "file" then
			local filepath = current_dir .. entry.name

			local hl_group = git_status[filepath]

			if hl_group then
				local name_start = line:find(entry.name, 1, true)
				if name_start then
					-- highlight the filename
					vim.fn.matchaddpos(hl_group, { { i, name_start, #entry.name } })
				end
			end
		end
	end
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	for name, opt in pairs(options.highlight) do
		if vim.fn.hlexists(name) == 0 then
			vim.api.nvim_set_hl(0, name, opt)
		end
	end

	local group = vim.api.nvim_create_augroup("OilGitStatus", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = group,
		callback = M.apply_git_highlights,
	})

	vim.api.nvim_create_autocmd({ "BufHidden" }, {
		group = group,
		callback = M.clear_highlights,
	})

	vim.api.nvim_create_autocmd({ "BufWritePost", "TermClose", "VimEnter" }, {
		group = group,
		callback = M.update_git_status,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "OilActionsPost",
		group = group,
		callback = function(_)
			M.update_git_status()
		end,
	})

	M.update_git_status()
end

return M
