-- some code from https://github.com/jcyrio/nvim_ai_command_finder
local M = {}

local options = {
	prompt = {
		template = [[
SYSTEM: You are a Neovim expert. Convert requests to Neovim commands. Only output the command without explanation.
USER: __PROMPT__
]],
	},
}

-- helper to run shell commands
function M.job_async(cmd, on_success, on_error)
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

-- trim, un-code-block, get first line
function M.sanitize_cmd(s)
	if not s or s == "" then
		return s
	end
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	s = s:gsub("^```%w*%s*", ""):gsub("%s*```%s*$", "")
	s = (s:match("([^\r\n]+)") or s)
	s = s:gsub("^`+", ""):gsub("`+$", ""):gsub("^%s*:%s*", "")
	return s
end

function M.gen_command(request, callback)
	local prompt = options.prompt.template
	prompt = string.gsub(prompt, "__PROMPT__", request)

	local escaped = "prompt " .. vim.fn.shellescape(prompt)
	M.job_async({ "zsh", "-ic", escaped }, function(response)
		local cleaned = vim.trim(response:gsub("^[^\n]*\n", ""))
		callback(cleaned)
	end, vim.notify)
end

function M.ask()
	vim.ui.input({ prompt = "Command: " }, function(query)
		if query and query ~= "" then
			vim.notify("Processing request...")

			M.gen_command(query, function(command)
				vim.fn.feedkeys(":" .. M.sanitize_cmd(command), "n")
			end)
		end
	end)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M
