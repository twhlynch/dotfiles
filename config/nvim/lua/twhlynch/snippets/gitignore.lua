---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local function snip(name, ignores)
	return s(name, fmta("# " .. name .. "\n" .. table.concat(ignores, "\n") .. "\n", {}))
end

return {
	snip("python", {
		"/.venv/",
		"__pycache__/",
		"*.py[cod]",
		"/build/",
		"/*.egg-info/",
	}),
	snip("node", {
		"/node_modules/",
		"/dist/",
		"/build/",
		"/.env",
		"/.env.*",
	}),
	snip("worker", {
		"/.wrangler",
		"/worker-configuration.d.ts",
	}),
	snip("os", {
		"/.DS_Store",
		"*:Zone.Identifier",
		"/[Tt]humbs.db",
		"[Dd]esktop.ini",
	}),
	snip("editors", {
		"/.vscode/",
		"/.vs/",
		"/.zed/",
		"/.idea/",
		"/.nvim.lua",
		"*.swp",
		"*.swo",
		"*.swn",
		"*.iml",
	}),
	snip("cpp", {
		"/build/",
		"/build-*/",
		"/Builds/",
		"/.cache/",
		"compile_commands.json",
	}),
	snip("out", {
		"*.out",
		"*.exe",
		"*.app",
		"*.o",
		"*.slo",
		"*.lo",
		"*.obj",
		"*.a",
		"*.dll",
		"*.so",
		"*.dylib",
		"*.lib",
		"*.pdb",
		"*.ilk",
		"*.so.*",
		"*.stackdump",
	}),
	snip("zig", {
		"/zig-out/",
		"/.zig-cache/",
		"/zig-pkg/",
	}),
	snip("lc3", {
		"*.obj",
		"*.lc3",
		"*.sym",
		"*.lst",
		"*.bin",
		"*.hex",
		"*.log",
	}),
	snip("temp", {
		"/tmp/",
		"/temp/",
		"*~",
		"._*",
		"*.bak",
		"*.tmp",
	}),
	s(
		{
			trig = "([%w,%-%+]+)%?",
			regTrig = true,
			name = "<lang>?",
			desc = "Fetch .gitignore",
		},
		f(function(_, sn)
			local input = sn.captures[1]

			local cmd = "curl -s https://www.toptal.com/developers/gitignore/api/" .. input
			local handle = io.popen(cmd)
			if not handle then
				return { "# error" }
			end

			local result = handle:read("*a")
			handle:close()

			if result == "" then
				return { "# none" }
			end

			-- split into lines
			local lines = {}
			for line in result:gmatch("([^\n]*)\n?") do
				table.insert(lines, line)
			end

			-- remove first 3 and last 2 wrapper lines
			lines = { unpack(lines, 4, #lines - 2) }

			-- remove trailing empty line
			if lines[#lines] == "" then
				table.remove(lines)
			end

			return lines
		end, {})
	),
}
