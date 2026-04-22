return {
	-- "twhlynch/notebook.nvim",
	dir = "~/Documents/Personal/notebook.nvim",
	opts = {
		-- stylua: ignore
		custom_theme_colors = {
			"#c48282", "#7e98e8", "#e0a363", "#7fa563", "#d8647e", "#6e94b2",
			"#4878CF", "#6ACC65", "#D65F5F", "#B47CC7", "#C4AD66", "#77BEDB",
		},

		keybind_prefix = "<leader>c",
		max_output_lines = 10,
		custom_plot_theme = true,
		-- cell_gap = 3,

		strings = {
			output_border = "┃   ",
			cell_border = "─",
			markdown_label = "   ",
			code_label = "   ",
			output_label = "   ",

			cell_executed = " ",
			cell_running = " ",
			truncated_output = "%s more lines",
			image_output = " × %s",
		},
	},
}
