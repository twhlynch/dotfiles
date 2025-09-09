return {
	{
		"echasnovski/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.cursorword",
		version = false,
		config = function()
			require("mini.cursorword").setup()
		end,
	},
	-- {
	-- 	"echasnovski/mini.comment",
	-- 	version = false,
	-- 	config = function()
	-- 		require("mini.comment").setup()
	-- 	end,
	-- },
	{
		"echasnovski/mini.operators",
		version = false,
		config = function()
			require("mini.operators").setup({
				evaluate = {
					prefix = "<leader>=",
					func = nil,
				},
				exchange = {
					prefix = "Gox",
					reindent_linewise = true,
				},
				multiply = {
					prefix = "Gom",
					func = nil,
				},
				replace = {
					prefix = "Gor",
					reindent_linewise = true,
				},
				sort = {
					prefix = "Gos",
					func = nil,
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({
				custom_surroundings = {
					["$"] = { output = { left = "$$ ", right = " $$" } },
					["9"] = { output = { left = "(", right = ")" } },
				},
				highlight_duration = 500,
				mappings = {
					add = "sa",
					delete = "sd",
					find = "sf",
					find_left = "sF",
					highlight = "sh",
					replace = "sr",
					update_n_lines = "sn",
					suffix_last = "l",
					suffix_next = "n",
				},
				n_lines = 20,
				respect_selection_type = false,
				search_method = "cover",
				silent = false,
			})
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		version = false,
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- TESTS
					-- #0ff & #0fff & #0ffff & #00ffff & #00fffff & #00ffffff
					-- 0x0ff & 0x0fff & 0x0ffff & 0x00ffff & 0x00fffff & 0x00ffffff
					-- x0ff & x0fff & x0ffff & x00ffff & x00fffff & x00ffffff
					-- [38;2;0;255;255m & [48;2;0;255;255m & [48;2;0;255;999m
					-- rgb(0, 255, 255) & rgb(0,255,255)
					-- rgba(0, 255, 255, 0.5) & rgba(0,255,255,0.5)
					hex_color = { -- from hipatterns.gen_highlighter.hex_color
						pattern = function()
							return "0?[#x]%x%x%x%x?%x?%x?%x?%x?%f[%W]" -- 3 - 8 length hex. # or 0x
						end,
						group = function(_, _, data)
							local hex = data.full_match

							if hex:sub(1, 2) == "0x" then
								hex = "#" .. hex:sub(3, #hex)
							end

							if #hex == 4 or #hex == 5 or #hex == 6 then
								-- rgb(a)(a) -> rrggbb
								local r, g, b = hex:sub(2, 2), hex:sub(3, 3), hex:sub(4, 4)
								hex = "#" .. r .. r .. g .. g .. b .. b
							elseif #hex == 9 or #hex == 8 then
								-- rrggbba(a) -> rrggbb
								hex = hex:sub(1, 7)
							end

							return hipatterns.compute_hex_color_group(hex, "bg")
						end,
						extmark_opts = { priority = 200 },
					},
					ansi_color = {
						pattern = function()
							return "%[[34]8;2;%d%d?%d?;%d%d?%d?;%d%d?%d?m%f[%W]" -- r;g;b ansi code for fg or bg
						end,
						group = function(_, _, data)
							local ansi = data.full_match

							local index = string.find(ansi, ";", 8)
							local index_2 = string.find(ansi, ";", index + 2)
							local index_3 = string.find(ansi, "m", index_2 + 2)

							local r = math.min(tonumber(ansi:sub(7, index - 1)) or 0, 255)
							local g = math.min(tonumber(ansi:sub(index + 1, index_2 - 1)) or 0, 255)
							local b = math.min(tonumber(ansi:sub(index_2 + 1, index_3 - 1)) or 0, 255)

							local hex = string.format("#%02X%02X%02X", r, g, b)

							return hipatterns.compute_hex_color_group(hex, "bg")
						end,
						extmark_opts = { priority = 200 },
					},
					rgb_color = {
						pattern = function()
							return "rgba?%(%d%d?%d?, ?%d%d?%d?, ?%d%d?%d?,? ?%d?%.?%d%)" -- rgb or rgba css color
						end,
						group = function(_, _, data)
							local rgb = data.full_match

							local isRGBA = rgb:sub(4, 4) == "a"

							local start = 5
							if isRGBA then
								start = start + 1
							end

							local index = string.find(rgb, ",", start)
							local start_1 = index
							if rgb:sub(start_1 + 1, start_1 + 1) == " " then
								start_1 = start_1 + 1
							end

							local index_2 = string.find(rgb, ",", start_1 + 2)
							local start_2 = index_2
							if rgb:sub(start_2 + 1, start_2 + 1) == " " then
								start_2 = start_2 + 1
							end

							local index_3 = string.find(rgb, (isRGBA and "," or ")"), start_2 + 2)

							local r = math.min(tonumber(rgb:sub(start, index - 1)) or 0, 255)
							local g = math.min(tonumber(rgb:sub(start_1 + 1, index_2 - 1)) or 0, 255)
							local b = math.min(tonumber(rgb:sub(start_2 + 1, index_3 - 1)) or 0, 255)

							local hex = string.format("#%02X%02X%02X", r, g, b)

							return hipatterns.compute_hex_color_group(hex, "bg")
						end,
						extmark_opts = { priority = 200 },
					},
				},
			})
		end,
	},
}