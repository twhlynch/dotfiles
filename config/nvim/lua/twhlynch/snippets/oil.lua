---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local function snip(name, ignores)
	return s(name, fmta(table.concat(ignores, "\n") .. "\n", {}))
end

return {
	snip("project", {
		".gitignore",
		".editorconfig",
		"README.md",
	}),
	snip("nvim", {
		"lua/plugin/init.lua",
		"plugin/plugin.lua",
		".stylua.toml",
		"selene.toml",
		"vim.toml",
	}),
	snip("python", {
		"pyproject.toml",
		"requirements.txt",
	}),
	snip("node", {
		".prettierrc.json",
		"index.html",
		"package.json",
		"tsconfig.json",
		"vite.config.ts",
		"worker.ts",
		"wrangler.toml",
	}),
	snip("cpp", {
		"src/main.cpp",
		".clang-format",
		".clang-tidy",
		".gersemirc",
		"CMakeLists.txt",
	}),
}
