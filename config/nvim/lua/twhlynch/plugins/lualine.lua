return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependecies = { "nvim-mini/mini.icons" },
	config = function()
		require("lualine").setup({
			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = false,
				disabled_filetypes = {
					"neo-tree",
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					function()
						return vim.b.copilot_suggestion_auto_trigger and "󱙺" or ""
					end,
					"location",
				},
				lualine_y = { "filetype" },
				lualine_z = {},
			},
		})
	end,
}
