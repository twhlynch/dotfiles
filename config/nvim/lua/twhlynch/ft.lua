-- filetype overrides
vim.filetype.add({
	extension = {
		mdx = "markdown",
		frag = "glsl",
		vert = "glsl",
		hlsl = "glsl",
		pl = "prolog",
		json = "jsonc",
		gltf = "jsonc",
		lp = "clingo",
		asm = "lc3",
		lc3 = "lc3",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "clingo",
	callback = function()
		vim.bo.commentstring = "% %s"
		vim.bo.comments = ":%"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tmux",
	callback = function()
		vim.schedule(function()
			vim.bo.syntax = "tmux"
		end)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", function()
			local qf_list = vim.fn.getqflist()
			local position = vim.api.nvim_win_get_cursor(0)
			table.remove(qf_list, position[1])
			vim.fn.setqflist(qf_list, "r")
			vim.api.nvim_win_set_cursor(0, position)
		end, { buffer = true, silent = true, desc = "Delete quickfix item" })
	end,
})
