local U = {}

-- run shell commands
function U.job_async(cmd, on_success, on_error)
	local stdout_lines = {}
	local stderr_lines = {}

	vim.fn.jobstart(cmd, {
		on_stdout = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(stdout_lines, line)
			end
		end,
		on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(stderr_lines, line)
			end
		end,
		on_exit = function(_, code, _)
			if code == 0 then
				on_success(table.concat(stdout_lines, "\n"))
			else
				if on_error then
					on_error(table.concat(stderr_lines, "\n") .. " (Exit code: " .. code .. ")")
				end
			end
		end,
		rpc = false,
	})
end

return U
