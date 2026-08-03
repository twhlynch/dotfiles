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
	{
		"nvim-mini/mini.operators",
		version = false,
		config = function()
			local inject_return = function(lines)
				if not lines[#lines]:find("^%s*return%s+") then
					lines[#lines] = "return " .. lines[#lines]
				end
			end

			local eval_lines = function(lines)
				local ft = vim.bo.filetype

				if lines[1]:sub(1, 2) == "! " then
					lines[1] = lines[1]:sub(2)
					ft = "zsh"
				end

				-- js
				if ft == "javascript" or ft == "typescript" or ft == "vue" or ft == "astro" then
					inject_return(lines)
					local wrapper = "console.log((() => {\n" .. table.concat(lines, "\n") .. "\n})());"
					return vim.fn.systemlist({ "node", "-e", wrapper })

				-- shell
				elseif ft == "bash" or ft == "sh" or ft == "zsh" then
					return vim.fn.systemlist({ ft, "-c", table.concat(lines, "\n") })

				-- python
				elseif ft == "python" then
					inject_return(lines)
					local wrapper = "def _():\n" .. table.concat(
						vim.tbl_map(function(l)
							return "    " .. l
						end, lines),
						"\n"
					) .. "\nprint(_())"
					return vim.fn.systemlist({ "python3", "-c", wrapper })

				-- lua fallback
				else
					local inspect_objects = function(...)
						local objects = {}
						for i = 1, select("#", ...) do
							local v = select(i, ...)
							table.insert(objects, vim.inspect(v))
						end

						return vim.split(table.concat(objects, "\n"), "\n")
					end

					inject_return(lines)
					return inspect_objects(assert(loadstring(table.concat(lines, "\n")))())
				end
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
