return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependecies = { "nvim-mini/mini.icons" },
	config = function()
		local base_config = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = {
				function()
					return vim.b.copilot_suggestion_auto_trigger and ((vim.g.copilot_suggestion_usage_string or "") .. "󱙺") or ""
				end,
				"notebook",
				"location",
			},
			lualine_y = { "filetype" },
			lualine_z = {},
		}

		local function extension(filetype, sections)
			return {
				filetypes = { filetype },
				sections = vim.tbl_deep_extend("force", vim.deepcopy(base_config), sections),
			}
		end

		local conf = require("vague.config.internal").current
		local c = conf.colors
		require("lualine").setup({
			extensions = {
				extension("oil", {
					lualine_c = {
						function()
							local ok, oil = pcall(require, "oil")
							if ok then
								return vim.fn.fnamemodify(oil.get_current_dir(), ":~")
							else
								return ""
							end
						end,
					},
				}),
				extension("neo-tree", {
					lualine_c = {
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
						end,
					},
				}),
			},
			sections = base_config,

			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = false,
				theme = {
					visual = {
						a = { fg = c.bg, bg = c.builtin, bold = conf.bold },
						b = { fg = c.property, bg = c.line },
					},
					replace = {
						a = { fg = c.bg, bg = c.string, bold = conf.bold },
						b = { fg = c.property, bg = c.line },
					},
					inactive = {
						a = { fg = c.property, bg = c.inactiveBg, bold = conf.bold },
						b = { fg = c.property, bg = c.inactiveBg },
						c = { fg = c.property, bg = c.inactiveBg },
					},
					normal = {
						a = { fg = c.bg, bg = c.operator, bold = conf.bold },
						b = { fg = c.property, bg = c.line },
						c = { fg = c.property, bg = c.inactiveBg },
					},
					insert = {
						a = { fg = c.bg, bg = c.delta, bold = conf.bold },
						b = { fg = c.property, bg = c.line },
					},
				},
			},
		})
	end,
}
