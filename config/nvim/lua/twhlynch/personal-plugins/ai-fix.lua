local U = require("twhlynch.personal-plugins.util")

local M = {}

local options = {
	prompt = {
		template = [[
In __FILE__:
```
__LINES__
```

Errors:
```
__ERRORS__
```

__PROMPT__

]],
		simple = [[
Fix the code. Keep your solution short and respond with ONLY fixed lines, not surrounding code.
If there is no error provided, figure out the issue anyway.
Specify the correct language in the markdown codeblock.
You MUST respond with only 1 codeblock and nothing else.
]],
		complex = [[
Respond with an explaination of the code, then an explaination of the error.
Then an explaination of how to fix the error with the full solution in code.
If there is no error provided, find issues in the code and fix them.
]],
	},
}

-- create response window
function M.popup(content)
	local buf = vim.api.nvim_create_buf(false, true)

	-- options
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

	local lines = vim.split(content, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.api.nvim_set_option_value("modifiable", false, { buf = buf }) -- has to be after

	-- size
	local columns = vim.o.columns
	local rows = vim.o.lines

	local max_line_length = 0
	for _, l in ipairs(lines) do
		if #l > max_line_length then
			max_line_length = #l
		end
	end

	local width = math.max(math.min(max_line_length, math.floor(columns * 0.5)), 0)
	local height = math.max(math.min(#lines, math.floor(rows * 0.5)), 0)

	local col = math.floor((columns - width) / 2)
	local row = math.floor((rows - height) / 2)

	local win_id = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
		noautocmd = true,
	})

	-- q, <esc>, <cr> to exit
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<cr>", "<cmd>close<CR>", { noremap = true, silent = true })

	vim.api.nvim_set_current_win(win_id)
end

function M.ask(visual, complex)
	local bufnr = vim.api.nvim_get_current_buf()

	-- __FILE__
	local filename = vim.fn.expand("%:t")
	local lines, errors = {}, {}

	if visual then -- visual selection
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		local start_line, end_line = start_pos[2] - 1, end_pos[2]

		-- __LINES__
		lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

		-- __ERRORS__
		for lnum = start_line, end_line - 1 do
			for _, diag in ipairs(vim.diagnostic.get(bufnr, { lnum = lnum })) do
				table.insert(errors, diag.message)
			end
		end
	else
		if complex then -- all lines
			-- __LINES__
			lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

			-- __ERRORS__
			for lnum = 0, #lines - 1 do
				for _, diag in ipairs(vim.diagnostic.get(bufnr, { lnum = lnum })) do
					table.insert(errors, diag.message)
				end
			end
		else -- +-5 lines
			-- __LINES__
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))

			lines = vim.api.nvim_buf_get_lines(bufnr, line - 5, line + 5, false)

			-- __ERRORS__
			local diagnostics = vim.diagnostic.get(bufnr, { lnum = line - 1 })

			-- prioritise same column
			for _, diag in pairs(diagnostics) do
				if diag.col <= col and diag.end_col >= col then
					table.insert(errors, diag.message)
				end
			end

			-- fallback to all
			if #errors == 0 and #diagnostics ~= 0 then
				for _, diag in pairs(diagnostics) do
					table.insert(errors, diag.message)
				end
			end
		end
	end

	local prompt = options.prompt.template
	prompt = string.gsub(prompt, "__PROMPT__", complex and options.prompt.complex or options.prompt.simple)
	prompt = string.gsub(prompt, "__FILE__", filename)
	prompt = string.gsub(prompt, "__LINES__", table.concat(lines, "\n"))
	prompt = string.gsub(prompt, "__ERRORS__", table.concat(errors, "\n"))

	vim.notify(prompt)
	local escaped = "prompt " .. vim.fn.shellescape(prompt)
	U.job_async({ "zsh", "-ic", escaped }, function(response)
		local cleaned = vim.trim(response:gsub("^[^\n]*\n", ""))
		M.popup(cleaned)
	end, vim.notify)
end

function M.visual_ask()
	M.ask(true)
end

function M.complex_ask()
	M.ask(false, true)
end

function M.complex_visual_ask()
	M.ask(true, true)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)
end

return M
