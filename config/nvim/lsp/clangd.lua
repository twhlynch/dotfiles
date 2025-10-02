local function flag_from_diagnostic(diagnostic)
	local flag = diagnostic.code or diagnostic.message:match("%[(.-)%]") or nil
	if flag == nil or flag:sub(1, 1) == "-" then
		return nil
	end
	return flag
end

local function insert_silence_at_line(bufnr, line, flag)
	local silence_text = " // NOLINT"
	if flag ~= nil then
		silence_text = silence_text .. "(" .. flag .. ")"
	end

	local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
	if current_line ~= nil then
		local current_line_len = #current_line
		vim.api.nvim_buf_set_text(bufnr, line, current_line_len, line, current_line_len, { silence_text })
	end
end

-- normal
local function insert_ignore_clang_warning()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.diagnostic.get(bufnr)

	for _, diagnostic in ipairs(diagnostics) do
		if line == diagnostic.lnum then
			local flag = flag_from_diagnostic(diagnostic)
			insert_silence_at_line(bufnr, diagnostic.lnum, flag)
		end
	end
end
-- visual
local function insert_ignore_clang_warnings()
	local bufnr = vim.api.nvim_get_current_buf()
	-- wtf is the right way to get visual selection position this sucks
	local vstart = vim.fn.getpos("v")[1] - 1
	local vend = vim.api.nvim_win_get_cursor(0)[1] - 1
	if vstart > vend then
		local temp = vstart
		vstart = vend
		vend = temp
	end
	local diagnostics = vim.diagnostic.get(bufnr)

	for _, diagnostic in ipairs(diagnostics) do
		if vstart <= diagnostic.lnum and diagnostic.lnum <= vend then
			local flag = flag_from_diagnostic(diagnostic)
			insert_silence_at_line(bufnr, diagnostic.lnum, flag)
		end
	end
end

---@diagnostic disable-next-line: unused-local
local function attach(client, bufnr)
	vim.keymap.set("n", "gcs", insert_ignore_clang_warning, { desc = "Insert diagnostic silence comments" })
	vim.keymap.set("x", "gcs", insert_ignore_clang_warnings, { desc = "Insert diagnostic silence comments" })
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(e)
		local bufnr = e.buf
		local client = vim.lsp.get_client_by_id(e.data.client_id)
		if client and client.name == "clangd" then
			attach(client, bufnr)
		end
	end,
})

---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--suggest-missing-includes",
	},
	filetypes = {
		"c",
		"cpp",
		"h",
		"hpp",
		"cc",
		"objc",
		"objcpp",
		"cuda",
		"mm",
		"m",
		"cc",
		"hh",
	},
	root_markers = {
		"compile_commands.json",
		".git",
		".clangd",
		".clang-tidy",
		".clang-format",
	},
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
	-- on_attach = nil TODO: on_attach does not get called?
}
