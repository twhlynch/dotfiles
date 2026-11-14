-- lualine usage string
local function update_copilot_usage()
	local token = vim.env.GH_TOKEN
	if not token then
		return
	end

	vim.system({ "curl", "-s", "-H", "Authorization: Bearer " .. token, "https://api.github.com/copilot_internal/user" }, { text = true }, function(data)
		if data.code ~= 0 then
			return
		end

		local ok, json = pcall(vim.json.decode, data.stdout)
		-- quota_reset_date = "2026-12-01",
		-- quota_reset_date_utc = "2026-12-01T00:00:00.000Z",
		-- quota_snapshots = {
		--   completions = {
		--     credits_used = 2000,
		--     entitlement = 2000,
		--     percent_remaining = 0,
		--     quota_remaining = 0,
		--     remaining = 0,

		if not (ok and json and json.quota_snapshots and json.quota_snapshots.completions and json.quota_snapshots.completions.percent_remaining) then
			return
		end

		local percentage_used = 100 - json.quota_snapshots.completions.percent_remaining
		local quota_remaining = json.quota_snapshots.completions.quota_remaining or 0
		local usage_string = "!"

		if percentage_used == 100 and quota_remaining == 0 then
			if json.quota_reset_date_utc then
				local function utc_timestamp(year, month, day, hour, min, sec)
					local local_time = os.time({
						year = year,
						month = month,
						day = day,
						hour = hour,
						min = min,
						sec = sec,
					})

					---@diagnostic disable-next-line: param-type-mismatch
					local utc = os.time(os.date("!*t", local_time))
					return local_time + os.difftime(local_time, utc)
				end

				local y, m, d, h, min, s = json.quota_reset_date_utc:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")

				local reset = utc_timestamp(tonumber(y), tonumber(m), tonumber(d), tonumber(h), tonumber(min), tonumber(s))

				local remaining = reset - os.time()

				local days = math.floor(remaining / 86400)
				local hours = math.floor((remaining % 86400) / 3600)

				usage_string = string.format("%dd %dh ", days, hours)
			end
		else
			usage_string = string.format("%.0f%% ", percentage_used):gsub("%%", "%%%%")
		end

		vim.schedule(function()
			vim.g.copilot_suggestion_usage_string = usage_string
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
