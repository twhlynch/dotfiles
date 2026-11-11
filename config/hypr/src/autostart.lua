local root = require("src")

return function(first)
	hl.exec_cmd("killall hypridle; hypridle")
	hl.exec_cmd("killall hyprpaper; hyprpaper")
	hl.exec_cmd("killall waybar; waybar")
	hl.exec_cmd("killall dunst; dunst")
	hl.exec_cmd("vicinae server")
	hl.exec_cmd("nm-applet --indicator")

	if first then
		hl.exec_cmd("wl-paste --type text --watch cliphist store")
		hl.exec_cmd("wl-paste --type image --watch cliphist store")

		hl.exec_cmd(root.browser, { workspace = "1 silent" })
		hl.dispatch(hl.dsp.focus({ workspace = 2 }))
		hl.exec_cmd(root.terminal, { workspace = "2 silent" })
	end
end
