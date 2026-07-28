return {
	"petertriho/nvim-scrollbar",
	opts = {
		max_lines = 10000,
		throttle_ms = 0,
		-- folds = 0,
		excluded_buftypes = {
			"terminal",
			"nowrite",
			"nofile",
			"prompt",
		},
		handlers = {
			cursor = true,
			diagnostic = true,
			gitsigns = true,
			handle = true,
			-- search = true,
		},
		marks = {
			GitAdd = {
				highlight = "Added",
				priority = 9,
			},
			GitChange = {
				highlight = "Changed",
				priority = 7,
			},
			GitDelete = {
				highlight = "Removed",
				priority = 8,
			},
		},
	},
	-- init = function()
	-- 	-- reduce lag
	-- 	local scrollbar = require("scrollbar")
	-- 	local old_render = scrollbar.render
	-- 	local timer = vim.uv.new_timer()
	--
	-- 	scrollbar.render = function(...)
	-- 		local args = { ... }
	--
	-- 		---@diagnostic disable-next-line: need-check-nil
	-- 		timer:stop()
	-- 		---@diagnostic disable-next-line: need-check-nil
	-- 		timer:start(16, 0, function() -- ~60fps
	-- 			vim.schedule(function()
	-- 				old_render(unpack(args))
	-- 			end)
	-- 		end)
	-- 	end
	-- end,
}
