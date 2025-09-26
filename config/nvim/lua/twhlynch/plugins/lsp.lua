-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
local lsp_list = {
	-- lua
	"lua_ls",
	-- bash
	"bashls",
	-- markdown
	"marksman",
	-- python
	"basedpyright",
	"ruff",
	-- rust
	"rust_analyzer",
	-- c, cpp, etc
	"clangd",
	"cmake",
	-- shaders
	"glsl_analyzer",
	-- java
	"jdtls",
	-- latex
	"texlab",
	-- ocaml
	"ocamllsp",
	-- web
	"eslint",
	"cssls",
	"html",
	"emmet_ls",
	"ts_ls",
	"vtsls",
	"vue_ls",
	"astro",
}

return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},

	opts = {
		automatic_enable = true,
		ensure_installed = lsp_list,
	},

	config = function(opts)
		require("mason").setup()
		require("mason-lspconfig").setup(opts)
		vim.lsp.enable(lsp_list)
		vim.lsp.enable("swipl")

		local l = vim.lsp
		l.handlers["textDocument/hover"] = function(_, result, ctx, config)
			config = config or { border = "rounded", focusable = true }
			config.focus_id = ctx.method
			if not (result and result.contents) then
				return
			end
			local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
			markdown_lines = vim.tbl_filter(function(line)
				return line ~= ""
			end, markdown_lines)
			if vim.tbl_isempty(markdown_lines) then
				return
			end
			return l.util.open_floating_preview(markdown_lines, "markdown", config)
		end

		local autocmd = vim.api.nvim_create_autocmd
		autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.vert", "*.frag", "*.hlsl" },
			callback = function(_)
				vim.cmd("set filetype=glsl")
			end,
		})
		autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.mdx" },
			callback = function(_)
				vim.cmd("set filetype=markdown")
			end,
		})

		autocmd("LspAttach", {
			callback = function(e)
				local keyopts = { buffer = e.buf }
				vim.keymap.set("n", "Gd", function()
					vim.lsp.buf.definition()
				end, keyopts)
				vim.keymap.set("n", "Gr", function()
					vim.lsp.buf.references()
				end, keyopts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({
						border = "rounded",
					})
				end, keyopts)
				-- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
				vim.keymap.set("n", "<leader>la", function()
					vim.lsp.buf.code_action()
				end, { buffer = e.buf, desc = "Code action" })
				vim.keymap.set("n", "<leader>lr", function()
					vim.lsp.buf.rename()
				end, { buffer = e.buf, desc = "Rename symbol" })
				vim.keymap.set("n", "<leader>lk", function()
					vim.diagnostic.open_float()
				end, { buffer = e.buf, desc = "Open float" })
			end,
		})
	end,
}