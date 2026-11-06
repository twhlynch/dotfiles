local root = require("src")
local autostart = require("src.autostart")
local actions = require("src.actions")
local bind = actions.bind

-- Windows

bind({ root.mod, "SHIFT", "R" }, function()
	autostart(false)
end)

bind({ root.mod, "Q" }, hl.dsp.window.close())

bind({ root.mod, "SHIFT", "space" }, actions.toggle_float)

bind({ root.mod, "F" }, hl.dsp.window.fullscreen({ mode = 1, action = "toggle" }))
bind({ root.mod, "SHIFT", "F" }, hl.dsp.window.fullscreen())

local resize_large = 80
bind({ root.mod, "ALT", "H" }, hl.dsp.window.resize({ x = -resize_large, y = 0, relative = true }))
bind({ root.mod, "ALT", "L" }, hl.dsp.window.resize({ x = resize_large, y = 0, relative = true }))
bind({ root.mod, "ALT", "K" }, hl.dsp.window.resize({ x = 0, y = resize_large, relative = true }))
bind({ root.mod, "ALT", "J" }, hl.dsp.window.resize({ x = 0, y = -resize_large, relative = true }))
bind({ root.mod, "CTRL", "H" }, hl.dsp.focus({ monitor = 0 }))
bind({ root.mod, "CTRL", "L" }, hl.dsp.focus({ monitor = 1 }))

bind({ root.mod, "P" }, hl.dsp.window.pin())

bind({ root.mod, "SHIFT", "P" }, actions.toggle_popup_float)

bind({ root.mod, "L" }, hl.dsp.focus({ direction = "right" }))
bind({ root.mod, "H" }, hl.dsp.focus({ direction = "left" }))
bind({ root.mod, "K" }, hl.dsp.focus({ workspace = "-1" }))
bind({ root.mod, "J" }, hl.dsp.focus({ workspace = "+1" }))
bind({ root.mod, "I" }, hl.dsp.focus({ direction = "down" }))
bind({ root.mod, "O" }, hl.dsp.focus({ direction = "up" }))

bind({ root.mod, "SHIFT", "L" }, hl.dsp.window.move({ direction = "right" }))
bind({ root.mod, "SHIFT", "H" }, hl.dsp.window.move({ direction = "left" }))
bind({ root.mod, "SHIFT", "K" }, hl.dsp.window.move({ workspace = "-1" }))
bind({ root.mod, "SHIFT", "J" }, hl.dsp.window.move({ workspace = "+1" }))
bind({ root.mod, "SHIFT", "I" }, hl.dsp.window.move({ direction = "down" }))
bind({ root.mod, "SHIFT", "O" }, hl.dsp.window.move({ direction = "up" }))

-- For focusing floating windows
bind({ root.mod, "space" }, actions.open_runner())

bind({ root.mod, "tab" }, hl.dsp.focus({ workspace = "previous" }))

bind({ root.mod, "T" }, actions.insert_empty_workspace())
bind({ root.mod, "G" }, actions.remove_empty_workspaces())

bind({ root.mod, "Return" }, actions.open_terminal())

bind({ root.mod, "mouse:272" }, hl.dsp.window.drag())
bind({ root.mod, "mouse:273" }, hl.dsp.window.resize())

bind({ "XF86PowerOff" }, hl.dsp.exec_cmd("hyprlock"))

bind({ "XF86AudioMute" }, hl.dsp.exec_cmd("volume-brightness.nu mute toggle"))
bind({ "XF86AudioLowerVolume" }, hl.dsp.exec_cmd("volume-brightness.nu volume down"))
bind({ "XF86AudioRaiseVolume" }, hl.dsp.exec_cmd("volume-brightness.nu volume up"))
bind({ "XF86AudioMicMute" }, hl.dsp.exec_cmd("volume-brightness.nu microphones toggle"))
bind({ "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("volume-brightness.nu brightness down"))
bind({ "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("volume-brightness.nu brightness up"))

bind({ "XF86AudioPause" }, hl.dsp.exec_cmd("playerctl play-pause"))
bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("playerctl play-pause"))
bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("playerctl previous"))
bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("playerctl next"))
