return {
	"ThePrimeagen/99",
	dependencies = { "saghen/blink.compat", version = "2.*" },
	config = function()
		local _99 = require("99")

		_99.setup({
			model = "", -- default
			provider = _99.Providers.OpenCodeProvider,
			tmp_dir = "/tmp/99",
			completion = { source = "blink" },
			md_files = { "AGENT.md" },
		})

		vim.keymap.set("v", "<leader>99", _99.visual)
		vim.keymap.set("n", "<leader>9x", _99.stop_all_requests)
		vim.keymap.set("n", "<leader>9s", _99.search)
	end,
}
