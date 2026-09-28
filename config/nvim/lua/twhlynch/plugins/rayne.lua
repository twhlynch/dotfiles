return {
	dir = "~/Documents/Personal/rayne.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		lldb_server_path = "/opt/homebrew/opt/llvm/bin/lldb-server",
	},
	init = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>R", group = "13 Rayne", icon = { icon = "", color = "blue" } },

			{ "<leader>Rd", icon = { icon = "", color = "blue" } },
			{ "<leader>Ra", icon = { icon = "", color = "blue" } },
			{ "<leader>Rl", icon = { icon = "", color = "green" } },
			{ "<leader>Rb", icon = { icon = "", color = "green" } },
			{ "<leader>Rg", icon = { icon = "", color = "azure" } },
			{ "<leader>Rr", icon = { icon = "", color = "green" } },

			{ "<leader>RD", icon = { icon = "", color = "blue" } },
			{ "<leader>RA", icon = { icon = "", color = "blue" } },
			{ "<leader>RL", icon = { icon = "", color = "green" } },
			{ "<leader>RB", icon = { icon = "", color = "green" } },
			{ "<leader>RG", icon = { icon = "", color = "azure" } },

			{ "<leader>Ru", icon = { icon = "󰏕", color = "azure" } },
			{ "<leader>Rv", icon = { icon = "", color = "azure" } },
		})
	end,
	keys = {
		 -- stylua: ignore start
		{ "<leader>Rb", function() require("rayne.android").build() end, desc = "Android: build" },
		{ "<leader>Rl", function() require("rayne.android").build_install_launch() end, desc = "Android: launch" },
		{ "<leader>Rd", function() require("rayne.android").build_install_launch_attach() end, desc = "Android: debug" },
		{ "<leader>Ra", function() require("rayne.android").attach() end, desc = "Android: attach" },
		{ "<leader>Rg", function() require("rayne.android").generate() end, desc = "Android: generate" },
		{ "<leader>Rr", function() require("rayne.android").build_install_launch_release() end, desc = "Android: release" },

		{ "<leader>RB", function() require("rayne.macos").build() end, desc = "MacOS: build" },
		{ "<leader>RL", function() require("rayne.macos").build_launch() end, desc = "MacOS: launch" },
		{ "<leader>RD", function() require("rayne.macos").build_launch_attach() end, desc = "MacOS: debug" },
		{ "<leader>RA", function() require("rayne.macos").attach() end, desc = "MacOS: attach" },
		{ "<leader>RG", function() require("rayne.macos").generate() end, desc = "MacOS: generate" },

		{ "<leader>Ru", function() require("rayne.android").upload_quest_build() end, desc = "Upload quest build" },
		{ "<leader>Rv", function() require("rayne.tools").bump_version() end, desc = "Bump VERSION" },
		-- stylua: ignore end
	},
}
