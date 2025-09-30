local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s(
		"lc3",
		fmta(
			[[.ORIG x3000

<>

HALT

.END]],
			{ i(1) }
		)
	),
}
