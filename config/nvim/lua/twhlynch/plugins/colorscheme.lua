return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			local bg = "#000000"
			local bg_dark = "#000000"
			local bg_highlight = "#0a0d3c"
			local bg_search = "#074a80"
			local bg_visual = "#122f46"
			local fg = "#CBE0F0"
			local fg_dark = "#e6e6e6"
			local fg_gutter = "#929699"
			local border = "#9da0a2"

			require("tokyonight").setup({
				transparent = true,
				style = "night",
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})

			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
