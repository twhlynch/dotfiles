local M = {}

local options = {
	notify = print, -- output function
	debug = true,
}

function M.is_buffer_formatted(original_buffer, callback)
	local conform = require("conform")

	local original_content = vim.api.nvim_buf_get_lines(original_buffer, 0, -1, false)

	local formatting_buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(formatting_buffer, "filetype", vim.bo[original_buffer].filetype)
	vim.api.nvim_buf_set_lines(formatting_buffer, 0, -1, false, original_content)

	conform.format({ bufnr = formatting_buffer, async = true }, function(error, did_edit)
		vim.api.nvim_buf_delete(formatting_buffer, {})

		if error and options.debug then
			vim.notify(error)
		end

		callback(not did_edit)
	end)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("FormatReminder", { clear = true }),
		callback = function(args)
			M.is_buffer_formatted(args.buf, function(formatted)
				if not formatted then
					options.notify("Did Your forget to format?")
				end
			end)
		end,
	})
end

return M
