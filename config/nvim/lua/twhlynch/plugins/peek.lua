return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup()
		vim.keymap.set("n", "<leader>po", require("peek").open, { desc = "Open Peek preview", noremap = true })
		vim.keymap.set("n", "<leader>pc", require("peek").close, { desc = "Close Peek preview", noremap = true })
	end,
}
