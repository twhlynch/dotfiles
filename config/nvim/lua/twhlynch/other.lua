local function open_files_matching(pattern)
	local files = vim.fn.systemlist("rg --files -g '" .. pattern .. "'")
	for _, file in ipairs(files) do
		vim.cmd("edit " .. vim.fn.fnameescape(file))
	end
end

vim.api.nvim_create_user_command("OpenAll", function(opts)
	local glob = opts.args
	if not glob or glob == "" then
		print("Usage: :OpenAll <pattern>")
		return
	end

	open_files_matching(glob)
end, { nargs = 1 })
