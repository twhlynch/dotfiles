return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				bash = { "shfmt" },
				zig = { "zigfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				astro = { "prettier" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		})
		vim.keymap.set({ "n" }, "<leader>lf", function()
			require("conform").format(nil, function(error, did_edit)
				print((did_edit and "" or "Already ") .. "Formatted")
			end)
		end, { noremap = true, silent = true, desc = "Format current buffer" })
	end,
}
