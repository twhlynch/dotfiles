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
	"ltex_plus",
	"texlab",
	"tinymist",
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
	"mdx-analyzer",
	-- configs
	"yamlls",
}

local mason_tools = {
	-- c, cpp, etc
	"clang-format",
	"gersemi", -- cmake
	-- ocaml
	"ocamlformat",
	-- web
	"prettier",
	-- shell
	"shfmt", --bash
	"beautysh", -- zsh
	-- lua
	"stylua",
	-- latex
	"bibtex-tidy",
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
		local mason = require("mason")
		local registry = require("mason-registry")
		local lspconfig = require("mason-lspconfig")

		mason.setup()
		lspconfig.setup(opts)

		local installed = {}
		local mapping = lspconfig.get_mappings()

		for _, name in ipairs(lsp_list) do
			local mapped = mapping.lspconfig_to_mason[name] or nil
			if mapped then
				table.insert(mason_tools, mapped)
			end
		end

		for _, name in ipairs(mason_tools) do
			local mapped = mapping.lspconfig_to_mason[name] or name
			local package = registry.get_package(mapped)
			if package then
				if not installed[package] then
					installed[package] = true
					if not package:is_installed() then
						vim.notify("Installing Mason package: " .. package.name, vim.log.levels.INFO)
						package:once("install:success", function()
							vim.notify("Installed Mason package: " .. package.name, vim.log.levels.INFO)
						end)
						package:once("install:failed", function()
							vim.notify("Failed to install Mason package: " .. name, vim.log.levels.ERROR)
						end)
						package:install()
					end
				end
			else
				vim.notify("Invalid Mason package: " .. name, vim.log.levels.ERROR)
			end
		end

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