local M = {}

local all_comments = {}
local last_fetch_time = 0
local REFRESH_INTERVAL = 1800 -- 30 minutes
local DEBUG = false

local ns = vim.api.nvim_create_namespace("pr_review_comments")
vim.api.nvim_set_hl(0, "ReviewCommentVirtualText", { fg = "#7E98E8", bg = "NONE", italic = true })

local function debug(str)
	if DEBUG then
		vim.notify("Debug: " .. str, vim.log.levels.INFO)
	end
end

-- helper to run shell commands
local function job_async(cmd, on_success, on_error)
	local stdout_lines = {}
	local stderr_lines = {}

	vim.fn.jobstart(cmd, {
		on_stdout = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(stdout_lines, line)
			end
		end,
		on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(stderr_lines, line)
			end
		end,
		on_exit = function(_, code, _)
			if code == 0 then
				on_success(table.concat(stdout_lines, "\n"))
			else
				if on_error then
					on_error(table.concat(stderr_lines, "\n") .. " (Exit code: " .. code .. ")")
				end
			end
		end,
		rpc = false,
	})
end

function M.get_pr_review_comments()
	last_fetch_time = os.time() -- even if it fails

	local current_file_path = vim.fn.expand("%:~:.")
	if not current_file_path then
		return
	end

	local function process_comments_response(comments_response)
		local comments = vim.json.decode(comments_response)
		table.sort(comments, function(a, b)
			return a.line < b.line
		end)

		local organized_comments = {}
		for _, comment in ipairs(comments) do
			local path = comment.path
			if path then
				organized_comments[path] = organized_comments[path] or {}
				table.insert(organized_comments[path], {
					author = comment.author,
					line = comment.line,
					body = comment.body,
				})
			end
		end

		all_comments = organized_comments
		M.show_comments_in_buffer()
	end

	local function handle_error(msg)
		vim.notify("PR Review Comments Error: " .. msg, vim.log.levels.ERROR)
	end

	-- check if in a git repo
	debug("get is repo")
	job_async({ "git", "rev-parse", "--is-inside-work-tree" }, function(is_repo)
		if vim.trim(is_repo) ~= "true" then
			return
		end

		-- get current branch
		debug("get current branch")
		job_async({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, function(current_branch)
			current_branch = vim.trim(current_branch)

			-- check internet
			debug("check internet")
			job_async({ "ping", "-c", "1", "8.8.8.8" }, function(_)
				-- spacer :3

				-- get latest open pr from current branch
				debug("get pr")
				job_async({ "gh", "pr", "list", "--head", current_branch, "--state", "open", "--json", "number", "-q", ".[0].number" }, function(pr_number)
					pr_number = vim.trim(pr_number)
					if pr_number == "" then -- no pr found
						return
					end

					-- get upstream repo name
					debug("get upstream name")
					job_async({ "gh", "repo", "view", "--json", "owner,name", "-q", '"\\(.owner.login)/\\(.name)"' }, function(repo_name)
						repo_name = vim.trim(repo_name)
						if repo_name == "" then
							vim.notify("Could not determine repository name.", vim.log.levels.ERROR)
							return
						end

						-- get review comments
						debug("get comments")
						local api_path = string.format("repos/%s/pulls/%s/comments", repo_name, pr_number)
						job_async({ "gh", "api", api_path, "--jq", "[.[] | {author: .user.login, path: .path, line: .original_line, body: .body}]" }, process_comments_response, handle_error)
					end, handle_error) -- repo name
				end, handle_error) -- latest pr
			end, nil) -- fail silently if no wifi
		end, nil) -- branch (fails if no commits)
	end, nil) -- is repo (fails if no repo)
end

function M.show_comments_in_buffer()
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) -- clear virtual text

	local lines_with_comments = M.get_comments_by_lines()

	for line, comments_on_line in pairs(lines_with_comments) do
		local virt_text = {}
		for i, comment in ipairs(comments_on_line) do
			local prefix = i > 1 and " | " or " " -- multiple comments
			table.insert(virt_text, {
				prefix .. comment.author .. ": " .. comment.body,
				"ReviewCommentVirtualText",
			})
		end
		vim.api.nvim_buf_set_extmark(vim.api.nvim_get_current_buf(), ns, line, 0, {
			virt_text = virt_text,
			virt_text_pos = "eol",
			priority = 99, -- before gitsigns blame
		})
	end

	require("scrollbar").throttled_render() -- refresh scrollbar
end

function M.get_current_line_comments()
	local comments_for_file = M.get_comments_by_lines()
	local current_line = vim.fn.getpos(".")[2] - 1
	local comments_at_line = comments_for_file[current_line]
	if comments_at_line and #comments_at_line ~= 0 then
		local comments_text = ""
		for i, comment in ipairs(comments_at_line) do
			local prefix = i > 1 and "\n" or "" -- multiple comments
			comments_text = comments_text .. prefix .. comment.author .. ": " .. comment.body
		end
		vim.notify(comments_text)
	end
end

function M.get_comments_by_lines()
	local comments_for_file = M.get_comments_for_buffer(nil)

	local lines_with_comments = {}
	for _, comment in ipairs(comments_for_file) do
		lines_with_comments[comment.line] = lines_with_comments[comment.line] or {}
		table.insert(lines_with_comments[comment.line], comment)
	end

	return lines_with_comments
end

function M.get_comments_for_buffer(reqbufnr)
	local bufnr = vim.api.nvim_get_current_buf()
	if reqbufnr and reqbufnr ~= bufnr then
		return {}
	end

	local current_file_path = vim.fn.expand("%:~:.")
	if not current_file_path then
		return {}
	end

	local comments_for_file = all_comments[current_file_path]
	if not comments_for_file then
		return {}
	end

	local review_marks = {}

	for _, comment in ipairs(comments_for_file) do
		local line = comment.line - 1 -- neovim lines are 0 indexed
		table.insert(review_marks, { author = comment.author, body = comment.body, line = line, text = "@", type = "Hint", level = 1 })
	end

	return review_marks
end

function M.auto_refresh_comments()
	if (os.time() - last_fetch_time) >= REFRESH_INTERVAL then
		M.get_pr_review_comments()
	end
end

require("scrollbar.handlers").register("ReviewComments", M.get_comments_for_buffer)
M.auto_refresh_comments()

vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter", "BufWritePost", "FocusGained" }, {
	group = vim.api.nvim_create_augroup("PRReviewCommentsGroup", { clear = false }),
	callback = function()
		local buftype = vim.bo.buftype
		if buftype == "terminal" or buftype == "nowrite" or buftype == "nofile" then
			return
		end

		M.auto_refresh_comments()
		M.show_comments_in_buffer()
	end,
})

return M
