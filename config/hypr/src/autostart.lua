local root = require("src")

return function(first)
	hl.exec_cmd("killall hypridle; hypridle")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")

	if first then
		hl.exec_cmd(root.browser, { workspace = "1 silent" })
		hl.dispatch(hl.dsp.focus({ workspace = 2 }))
		hl.exec_cmd(root.terminal, { workspace = "2 silent" })
	end
end
