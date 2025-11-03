return {
	{
		"nvim-mini/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.cursorword",
		version = false,
		config = function()
			require("mini.cursorword").setup()
		end,
	},
	-- {
	-- 	"nvim-mini/mini.comment",
	-- 	version = false,
	-- 	config = function()
	-- 		require("mini.comment").setup()
	-- 	end,
	-- },
	{
		"nvim-mini/mini.operators",
		version = false,
		config = function()
			local inspect_objects = function(...)
				local objects = {}
				for i = 1, select("#", ...) do
					local v = select(i, ...)
					table.insert(objects, vim.inspect(v))
				end

				return vim.split(table.concat(objects, "\n"), "\n")
			end
			local eval_lines = function(lines)
				local lines_copy, n = vim.deepcopy(lines), #lines
				lines_copy[n] = (lines_copy[n]:find("^%s*return%s+") == nil and "return " or "") .. lines_copy[n]
				local str_to_eval = table.concat(lines_copy, "\n")

				local ft = vim.bo.filetype
				if ft == "javascript" or ft == "typescript" then
					-- js
					local wrapper = "console.log((() => {\n" .. str_to_eval .. "\n})());"
					return vim.fn.systemlist({ "node", "-e", wrapper })
				elseif ft == "bash" or ft == "sh" or ft == "zsh" then
					-- shell
					return vim.fn.systemlist({ "bash", "-c", str_to_eval })
				elseif ft == "python" then
					-- python
					local wrapper = "def _():\n" .. table.concat(
						vim.tbl_map(function(l)
							return "    " .. l
						end, lines_copy),
						"\n"
					) .. "\nprint(_())"
					return vim.fn.systemlist({ "python3", "-c", wrapper })
				end

				-- lua as fallback
				return inspect_objects(assert(loadstring(str_to_eval))())
			end

			local function evaluate(content)
				local lines, submode = content.lines, content.submode
				if submode ~= vim.api.nvim_replace_termcodes("<C-v>", true, true, true) then
					return eval_lines(lines)
				end
				return vim.tbl_map(function(l)
					return eval_lines({ l })[1]
				end, lines)
			end

			require("mini.operators").setup({
				evaluate = {
					prefix = "<leader>=",
					func = evaluate,
				},
				exchange = {
					prefix = "Gox",
					reindent_linewise = true,
				},
				multiply = {
					prefix = "Gom",
					func = nil,
				},
				replace = {
					prefix = "Gor",
					reindent_linewise = true,
				},
				sort = {
					prefix = "Gos",
					func = nil,
				},
			})
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({
				custom_surroundings = {
					["$"] = { output = { left = "$$ ", right = " $$" } },
					["9"] = { output = { left = "(", right = ")" } },
				},
				highlight_duration = 500,
				mappings = {
					add = "sa",
					delete = "sd",
					find = "sf",
					find_left = "sF",
					highlight = "sh",
					replace = "sr",
					update_n_lines = "sn",
					suffix_last = "l",
					suffix_next = "n",
				},
				n_lines = 20,
				respect_selection_type = false,
				search_method = "cover",
				silent = false,
			})
		end,
	},
}
