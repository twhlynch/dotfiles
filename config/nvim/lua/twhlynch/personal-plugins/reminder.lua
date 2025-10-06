local M = {}

local options = {
	notify = print, -- output function
	debug = true,
}

local ns_id = vim.api.nvim_create_namespace("FormatReminderDiff")

-- highlight lines that arent formatted
local function highlight_unformatted_lines(bufnr, before, after)
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	local before_text = table.concat(before, "\n")
	local after_text = table.concat(after, "\n")

	local hunks = vim.diff(before_text, after_text, { result_type = "indices" })
	if not hunks or #hunks == 0 then
		return
	end

	for _, hunk in ipairs(hunks) do
		local start_a, count_a = hunk[1], hunk[2]

		-- vim.diff indices are 0 based
		local start_line = start_a
		local end_line = start_a + count_a

		vim.api.nvim_buf_set_extmark(bufnr, ns_id, start_line, 0, {
			end_line = end_line,
			hl_group = "DiffChange",
			hl_eol = true,
		})
	end
end

function M.is_buffer_formatted(original_buffer, callback)
	local conform = require("conform")

	local original_content = vim.api.nvim_buf_get_lines(original_buffer, 0, -1, false)

	local formatting_buffer = vim.api.nvim_create_buf(false, true)
	vim.bo[formatting_buffer].filetype = vim.bo[original_buffer].filetype
	vim.bo[formatting_buffer].fixeol = vim.bo[original_buffer].fixeol
	vim.bo[formatting_buffer].fixendofline = vim.bo[original_buffer].fixendofline
	vim.bo[formatting_buffer].endoffile = vim.bo[original_buffer].endoffile
	vim.api.nvim_buf_set_lines(formatting_buffer, 0, -1, false, original_content)

	conform.format({ bufnr = formatting_buffer, async = true }, function(error, did_edit)
		local formatted_content = vim.api.nvim_buf_get_lines(formatting_buffer, 0, -1, false)
		vim.api.nvim_buf_delete(formatting_buffer, {})

		if error and options.debug then
			vim.notify(error)
		end

		local formatted = not did_edit

		if not formatted then
			highlight_unformatted_lines(original_buffer, original_content, formatted_content)
		else
			vim.api.nvim_buf_clear_namespace(original_buffer, ns_id, 0, -1)
		end

		callback(formatted)
	end)
end

function M.setup(opts)
	options = vim.tbl_deep_extend("keep", opts or {}, options)

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("FormatReminder", { clear = true }),
		callback = function(args)
			M.is_buffer_formatted(args.buf, function(formatted)
				if not formatted then
					options.notify("Did you forget to format?")
				end
			end)
		end,
	})

	local conform = require("conform")
	local old_format = conform.format
	conform.format = function(opts, ...)
		vim.api.nvim_buf_clear_namespace((opts or {}).bufnr or 0, ns_id, 0, -1)
		old_format(opts, ...)
	end
end

return M
