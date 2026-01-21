-- load source file when attaching to a header for better goto definition
local load_source = function(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == nil or name == "" then
		return
	end

	local ext = name:match("^.*%.([^%.]+)$")
	if ext ~= "h" and ext ~= "hpp" then
		return
	end

	local base = name:match("^(.*)%.")
	if base == nil or base == "" then
		return
	end

	-- find source file
	local source_file = nil
	local candidates = { base .. ".cpp", base .. ".c" }
	for _, f in ipairs(candidates) do
		---@diagnostic disable-next-line: undefined-field
		if vim.loop.fs_stat(f) then
			source_file = vim.fn.fnamemodify(f, ":p")
			break
		end
	end

	if source_file == nil then
		return
	end

	-- not already loaded
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(b) then
			local loaded_name = vim.api.nvim_buf_get_name(b)
			if loaded_name == source_file then
				return
			end
		end
	end

	-- load in background
	local b = vim.fn.bufadd(source_file)
	vim.fn.bufload(b)

	-- properly init buffer?
	vim.api.nvim_buf_call(b, function()
		vim.cmd("filetype detect")
		vim.api.nvim_exec_autocmds("BufReadPost", { buffer = b })
	end)
end

---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--header-insertion-decorators",
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
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	on_attach = function(_, bufnr)
		load_source(bufnr)
	end,
}
