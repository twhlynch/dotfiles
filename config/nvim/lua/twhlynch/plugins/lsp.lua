return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"jcha0713/cmp-tw2css",
		"hrsh7th/nvim-cmp",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = {
				"lua_ls",
				"bashls",
				"marksman",
				"pyright",
				"rust_analyzer",
				"eslint",
				"cssls",
				"html",
				"clangd",
				"cmake",
				"emmet_ls",
				"glsl_analyzer",
				"jdtls",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "tab",
										indent_size = "4",
									},
								},
							},
						},
					})
				end,

				["pyright"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "off",
									autoImportCompletions = true,
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,

				["rust_analyzer"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								checkOnSave = {
									command = "clippy",
								},
							},
						},
					})
				end,

				["clangd"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.clangd.setup({
						capabilities = capabilities,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--cross-file-rename",
							"--completion-style=detailed",
							"--header-insertion=iwyu",
							"--suggest-missing-includes",
						},
						root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
					})
				end,

				["cmake"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.cmake.setup({
						capabilities = capabilities,
						root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
					})
				end,

				["emmet_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.emmet_ls.setup({
						capabilities = capabilities,
						filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
						init_options = {
							html = {
								options = {
									-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
									["bem.enabled"] = true,
								},
							},
						},
					})
				end,
			},
		})
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

		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		vim.api.nvim_set_hl(0, "CmpNormal", {})
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = vim.NIL,
			}),

			window = {
				completion = {
					scrollbar = false,
					border = "rounded",
					winhighlight = "Normal:CmpNormal",
				},
				documentation = {
					scrollbar = false,
					border = "rounded",
					winhighlight = "Normal:CmpNormal",
				},
			},
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry, ctx)
						return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
					end,
				},
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "cmdline" },
				{ name = "buffer" },
			}, {}),
		})

		local autocmd = vim.api.nvim_create_autocmd
		autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.vert", "*.frag" },
			callback = function(_)
				vim.cmd("set filetype=glsl")
			end,
		})

		autocmd("LspAttach", {
			callback = function(e)
				local opts = { buffer = e.buf }
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({
						border = "rounded",
					})
				end, opts)
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
				vim.keymap.set("n", "<leader>ln", function()
					vim.diagnostic.goto_next()
				end, { buffer = e.buf, desc = "Goto next" })
				vim.keymap.set("n", "<leader>lp", function()
					vim.diagnostic.goto_prev()
				end, { buffer = e.buf, desc = "Goto previous" })
			end,
		})
	end,
}
