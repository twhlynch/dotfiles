return {
	{
		"eandrju/cellular-automaton.nvim",
		config = function()
			vim.keymap.set({ "n" }, "<leader>cell", "<cmd>CellularAutomaton make_it_rain<CR>", { noremap = true, silent = true, desc = "Make it rain" })
		end,
	},
	-- {
	-- 	-- "nullromo/fishtank.nvim",
	-- 	"twhlynch/fishtank.nvim", -- until my pr is merged
	-- 	opts = {
	-- 		sprite = {
	-- 			right = ">< °>",
	-- 			left = "<° ><",
	-- 			-- -- fish collection --
	-- 			--    ><^, ⋗  ⋖ ⹁^><
	-- 			--     >< ^>  <^ ><
	-- 			--      >< ⋗  ⋖ ><
	-- 			--       ><>  <><
	-- 			--     >< *>  <* ><
	-- 			--     >< °>  <° ><
	-- 			--  ><((((•>  <•))))><
	-- 			--   ><(((*>  <*)))><
	-- 		},
	-- 		screensaver = {
	-- 			enabled = true,
	-- 			timeout = 1000 * 60, -- 1 minute
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		local fishtank = require("fishtank")
	-- 		fishtank.setup(opts)
	-- 	end,
	-- },
}