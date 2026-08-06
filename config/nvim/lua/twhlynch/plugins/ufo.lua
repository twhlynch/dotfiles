return {
	"kevinhwang91/nvim-ufo",
	lazy = false,
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		provider_selector = function(_, _, _)
			return { "treesitter", "indent" }
		end,
		fold_virt_text_handler = require("nvim-plugins.ufo_folds").fold_virt_text_handler,
		enable_get_fold_virt_text = true,
		open_fold_hl_timeout = 0,
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	keys = {
		-- stylua: ignore start
		{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
		{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		{ "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold at cursor" },
		-- stylua: ignore end
	},
}
