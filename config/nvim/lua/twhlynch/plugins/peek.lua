return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup()
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		vim.keymap.set("n", "<leader>po", "<cmd>PeekOpen<CR>", { desc = "Open Peek preview", noremap = true })
		vim.keymap.set("n", "<leader>pc", "<cmd>PeekClose<CR>", { desc = "Close Peek preview", noremap = true })
	end,
}
