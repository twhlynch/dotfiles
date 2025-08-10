return {
	{ "eandrju/cellular-automaton.nvim" },
	{
		-- "nullromo/fishtank.nvim",
		"twhlynch/fishtank.nvim", -- until my pr is merged
		opts = {
			screensaver = {
				enabled = true,
				timeout = 1000 * 60, -- 1 minute
				sprite = {
					right = ">< °>",
					left = "<° ><",
					-- -- fish collection --
					--    ><^, ⋗  ⋖ ⹁^><
					--     >< ^>  <^ ><
					--      >< ⋗  ⋖ ><
					--       ><>  <><
					--     >< *>  <* ><
					--     >< °>  <° ><
					--  ><((((•>  <•))))><
					--   ><(((*>  <*)))><
				},
			},
		},
		config = function(_, opts)
			local fishtank = require("fishtank")
			fishtank.setup(opts)
		end,
	},
}
