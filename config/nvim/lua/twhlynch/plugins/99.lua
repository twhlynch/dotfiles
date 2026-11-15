return {
	"ThePrimeagen/99",
	dependencies = { "saghen/blink.compat", version = "2.*" },
	config = function()
		local _99 = require("99")

		--- @class PiProvider : _99.Providers.BaseProvider
		local PiProvider = setmetatable({}, { __index = _99.Providers.BaseProvider })

		--- @param query string
		--- @param context _99.Prompt
		function PiProvider._build_command(_, query, context)
			return {
				"pi",
				"--print",
				"--model",
				context.model,
				query,
			}
		end

		function PiProvider._get_provider_name()
			return "PiProvider"
		end

		_99.setup({
			model = "", -- default
			provider = vim.fn.executable("opencode") == 1 and _99.Providers.OpenCodeProvider or PiProvider,
			tmp_dir = "/tmp/99",
			completion = { source = "blink" },
			md_files = { "AGENT.md" },
		})

		vim.keymap.set("v", "<leader>99", _99.visual)
		vim.keymap.set("n", "<leader>9x", _99.stop_all_requests)
		vim.keymap.set("n", "<leader>9s", _99.search)
	end,
}
