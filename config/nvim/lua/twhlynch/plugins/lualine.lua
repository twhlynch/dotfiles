return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependecies = { "nvim-mini/mini.icons" },
	config = function()
		local conf = require("vague.config.internal").current
		local c = conf.colors
		require("lualine").setup({
			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = false,
				disabled_filetypes = {
					"neo-tree",
				},
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
			sections = {
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
			},
		})
	end,
}
