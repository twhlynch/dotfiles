-- lualine usage string
local function update_copilot_usage()
	local creds = require("copilot.auth").get_creds()
	if not creds then
		return
	end

	local token
	for key, entry in pairs(creds) do
		if key:match("^github.com") then
			token = entry.oauth_token
			break
		end
	end
	if not token then
		return
	end

	vim.system({ "curl", "-s", "-H", "Authorization: Bearer " .. token, "https://api.github.com/copilot_internal/user" }, { text = true }, function(data)
		if data.code ~= 0 then
			return
		end

		local ok, json = pcall(vim.json.decode, data.stdout)

		if not ok or not json then
			return
		end

		vim.schedule(function()
			local completions = json.quota_snapshots.completions
			local percent_remaining = completions.percent_remaining

			local percentage_used = 100 - percent_remaining
			local usage_string = string.format("%.0f%% ", percentage_used)

			vim.g.copilot_suggestion_usage_string = usage_string:gsub("%%", "%%%%")
		end)
	end)
end

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = { enabled = false },
		nes = { enabled = false },
		suggestion = {
			enabled = true,
			auto_trigger = false,
			keymap = {
				accept = "<C-]>",
				dismiss = "<A-[>",
				next = false,
				prev = false,
			},
		},
		server_opts_overrides = {
			settings = {
				advanced = {
					inlineSuggestCount = 1,
				},
			},
		},
		filetypes = {
			["*"] = true,
		},
		logger = {
			print_log_level = vim.log.levels.OFF,
		},
		disable_limit_reached_message = true,
	},
	keys = {
		{
			"<leader>ct",
			function()
				require("copilot.suggestion").toggle_auto_trigger()
			end,
			desc = "Toggle Copilot Auto Trigger",
		},
	},
	init = function()
		-- global auto trigger toggle
		local auto_trigger = false

		local suggestion = require("copilot.suggestion")

		-- override with global trigger
		suggestion.should_auto_trigger = function()
			return auto_trigger
		end

		local old_toggle_auto_trigger = suggestion.toggle_auto_trigger
		---@diagnostic disable-next-line: duplicate-set-field
		suggestion.toggle_auto_trigger = function()
			old_toggle_auto_trigger()
			auto_trigger = not auto_trigger
			require("lualine").refresh()

			vim.print("Auto trigger is " .. (auto_trigger and "ON" or "OFF"))
			if auto_trigger then
				update_copilot_usage()
			end
		end

		-- print once when API limited
		local logger = require("copilot.logger")
		local old_trace = logger.trace
		local has_printed = false
		logger.trace = function(msg, ...)
			if msg == "API limited:" and not has_printed then
				vim.print("Copilot API limited")
				has_printed = true
			end
			old_trace(msg, ...)
		end
	end,
}
