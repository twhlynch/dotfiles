return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				json = { "jq" },
				html = { "prettier" },
				css = { "prettier" },
				bash = { "shfmt" },
				zig = { "zigfmt" },
			},
		})
	end,
}
