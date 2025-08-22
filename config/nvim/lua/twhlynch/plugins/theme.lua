return {
	"vague2k/vague.nvim",
	config = function()
		-- remove treesitter context changes
		require("vague.groups.treesitter-context").get_colors = function(_) end
		require("vague").setup({ transparent = true })
		vim.cmd("colorscheme vague")
		vim.cmd(":hi statusline guibg=NONE")
	end,
}
