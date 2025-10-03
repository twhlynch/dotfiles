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
	"mdx_analyzer",
	-- configs
	"yamlls",
}

local formatters = {
	lua = { "stylua" },
	python = { "black" },
	rust = { "rustfmt" },
	-- go = { "gofumpt" },
	cpp = { "clang-format" },
	c = { "clang-format" },
	cmake = { "gersemi" },
	bash = { "shfmt" },
	zsh = { "beautysh" },
	ocaml = { "ocamlformat" },
	tex = { "bibtex-tidy" },
	-- web
	javascript = { "prettier" },
	typescript = { "prettier" },
	json = { "prettier" },
	jsonc = { "prettier" },
	html = { "prettier" },
	css = { "prettier" },
	astro = { "prettier" },
	vue = { "prettier" },
	svg = { "prettier" },
}

local mason_tools = {
	-- lsp, dap, linter, formatter
}

return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} }, -- tools
		"neovim/nvim-lspconfig", -- lsp config data
		"stevearc/conform.nvim", -- formatter
	},

	opts = {
		automatic_enable = true,
		ensure_installed = lsp_list,
	},

	config = function(opts)
		local mason = require("mason")
		local registry = require("mason-registry")
		local lspconfig = require("mason-lspconfig")
		local conform = require("conform")

		mason.setup()
		lspconfig.setup(opts)

		local installed = {}
		local mapping = lspconfig.get_mappings()

		-- add lsps to tools list
		for _, name in ipairs(lsp_list) do
			local mapped = mapping.lspconfig_to_mason[name] or nil
			if mapped then
				table.insert(mason_tools, mapped)
			end
		end

		-- add formatters to tools list
		for _, value in pairs(formatters) do
			local name = value[1]
			if name then
				table.insert(mason_tools, name)
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
		-- ltex_plus doesnt configure correctly
		package.path = package.path .. ";" .. vim.fn.stdpath('config') .. "/lsp/?.lua"
		vim.lsp.config("ltex_plus", require("ltex_plus"))

		-- formatting
		conform.setup({
			formatters_by_ft = formatters,
			default_format_opts = {
				lsp_format = "fallback",
			},
			formatters = {
				beautysh = {
					append_args = { "--tab" },
				},
			},
		})

		vim.keymap.set({ "n" }, "<leader>lf", function()
			conform.format(nil, function(error, did_edit)
				print((did_edit and "" or "Already ") .. "Formatted")
			end)
		end, { noremap = true, silent = true, desc = "Format current buffer" })

		local autocmd = vim.api.nvim_create_autocmd
		autocmd("LspAttach", {
			callback = function(e)
				local keyopts = { buffer = e.buf }
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