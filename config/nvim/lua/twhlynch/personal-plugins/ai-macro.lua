-- some code from https://github.com/jcyrio/nvim_ai_command_finder
local U = require("twhlynch.personal-plugins.util")

local M = {}

local options = {
	prompt = {
		template = [[
SYSTEM: You are a Vim and Neovim expert. Convert requests to real Neovim commands or macros. Only output the command without explanation. Do not hallucinate. Do not make up commands.
USER: __PROMPT__
]],
	},
}

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
	U.job_async({ "zsh", "-ic", escaped }, function(response)
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