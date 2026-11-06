hl.window_rule({
	name = "pin",
	match = { pin = true },
	border_size = 2,
	border_color = "#8921ff9b #33125b",
})

hl.layer_rule({
	name = "wofi-blur",
	match = { namespace = "wofi" },
	blur = true,
	ignore_alpha = 0.3,
	-- no_anim = true,
})
