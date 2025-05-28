return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",

	dependencies = { "rafamadriz/friendly-snippets" },

	config = function()
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/twhlynch/snippets/" })

		local ls = require("luasnip")

		vim.keymap.set({ "i" }, "<Tab>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, { silent = true })
		vim.keymap.set({ "i" }, "<C-e>", function()
			ls.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-J>", function()
			ls.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-K>", function()
			ls.jump(-1)
		end, { silent = true })

		ls.config.setup({
			enable_autosnippets = true,
			region_check_events = "InsertEnter",
			delete_check_events = "InsertLeave",
		})
	end,
}
