return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	version = "1.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"folke/lazydev.nvim",
	},
	opts = {
		keymap = {
			["<C-space>"] = { "show", "hide", "fallback" },

			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },

			["<C-y>"] = { "select_and_accept", "fallback" },
			["<Tab>"] = { "select_and_accept", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				treesitter_highlighting = true,
			},

			ghost_text = { enabled = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				buffer = {
					min_keyword_length = 5,
					max_items = 5,
				},
			},
		},

		cmdline = {
			enabled = true,
			sources = { "buffer" },
			keymap = {
				preset = "default",
			},
			completion = {
				menu = { auto_show = true },
			},
		},

		snippets = { preset = "luasnip" },

		signature = { enabled = true },
	},
}