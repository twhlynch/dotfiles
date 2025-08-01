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
				html = { "prettier" },
				css = { "prettier" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		})
	end,
}
