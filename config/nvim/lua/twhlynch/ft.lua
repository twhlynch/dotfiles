-- filetype overrides
vim.filetype.add({
	extension = {
		mdx = "markdown",
		frag = "glsl",
		vert = "glsl",
		hlsl = "glsl",
		pl = "prolog",
		json = "jsonc",
		lp = "clingo",
		asm = "lc3",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "clingo",
	callback = function()
		vim.bo.commentstring = "% %s"
		vim.bo.comments = ":%"
	end,
})
