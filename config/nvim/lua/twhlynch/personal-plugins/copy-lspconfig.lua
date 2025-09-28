local M = {}

local options = {}

local LSP_PATH = vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp"
local TARGET_PATH = vim.fn.stdpath("config") .. "/lsp"

function M.copy_lspconfig(config)
	local source = LSP_PATH .. "/" .. config .. ".lua"
	local dest = TARGET_PATH .. "/" .. config .. ".lua"

	vim.fn.system({ "cp", source, dest })
end

function M.open_split(config)
	local file = TARGET_PATH .. "/" .. config .. ".lua"

	vim.api.nvim_command("vsplit")
	vim.api.nvim_command("edit " .. file)
end

function M.callback(selected)
	if not selected or selected == "" then
		return
	end

	M.copy_lspconfig(selected)
	vim.notify("Copied " .. selected, vim.log.levels.INFO)

	M.open_split(selected)
end

function M.copy_lsp()
	local files = vim.fn.readdir(LSP_PATH)

	local configs = {}
	for _, f in ipairs(files) do
		local filename = f:gsub("%.lua$", "")
		table.insert(configs, filename)
	end

	Snacks.picker.select(configs, {
		title = "Available LSPs",
	}, M.callback)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	vim.api.nvim_create_user_command("LspCopy", M.copy_lsp, {})
end

return M
