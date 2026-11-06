hl.config({
	general = {
		border_size = 1,
		gaps_in = 3,
		gaps_out = 4,

		col = {
			inactive_border = "#1C1C24",
			active_border = "#c48282",
		},

		layout = "scrolling",
		no_focus_fallback = true,

		resize_on_border = true,
		hover_icon_on_border = true,

		allow_tearing = false,
	},

	master = {
		mfact = 0.6,
		new_status = "master",
	},

	scrolling = {
		-- fullscreen_on_one_column = false,
		column_width = 0.58,
		-- focus_fit_method = 1,
		-- follow_focus = true,
		-- follow_min_visible = 0.4,
		-- explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		-- wrap_focus = true,
		-- wrap_swapcol = true,
		direction = "left",
	},

	decoration = {
		rounding = 4,

		blur = {
			enabled = true,
		},
		shadow = {
			enabled = true,
		},
	},

	animations = {
		enabled = true,
	},

	input = {
		sensitivity = 0.1,
		float_switch_override_focus = 0,

		touchpad = {
			disable_while_typing = false,
			natural_scroll = true,
			drag_lock = true,
		},
	},

	misc = {
		disable_hyprland_logo = true,

		enable_swallow = true,
		swallow_regex = "^.*$",

		on_focus_under_fullscreen = 2,
	},

	binds = {
		-- More intuitive when switching to previous workspace
		allow_workspace_cycles = true,

		hide_special_on_workspace_change = true,

		movefocus_cycles_fullscreen = true,
	},

	cursor = {
		inactive_timeout = 1,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	debug = {
		disable_logs = false,
	},
})
