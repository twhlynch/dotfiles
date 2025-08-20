local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local function header_guard()
	local filename = vim.fn.expand("%:t")
	local guard = string.upper(filename:gsub("%.", "_"):gsub("-", "_"))
	return guard
end

return {
	s(
		"header",
		fmta(
			[[
    #ifndef <>
    #define <>
    <>
    #endif // <>
    ]],
			{
				f(header_guard),
				f(header_guard),
				i(1),
				f(header_guard),
			}
		)
	),
	s("w", t("World::GetSharedInstance()")),
	s("world", t("World::GetSharedInstance()")),
	s("W", t("World* world = World::GetSharedInstance();")),
	s("log", fmta("RNDebug(<>);", { i(1) })),
	s("str", fmta('RNSTR("<>")', { i(1) })),
	s("cstr", fmta('RNCSTR("<>")', { i(1) })),
	s(
		"traverse",
		fmta(
			[[
	Traverse([&](SceneNode *node) {
		<>
	});
	]],
			{
				i(1),
			}
		)
	),
	s(
		"enumerate",
		fmta(
			[[
	Enumerate<<<>>>([&](<> *element, size_t index, bool &stop) {
		<>
	});
	]],
			{
				i(1, "Type"),
				rep(1),
				i(2),
			}
		)
	),
}
