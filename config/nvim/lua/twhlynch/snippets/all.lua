local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s("date", t(os.date("%Y/%m/%d"))),
	s("user", t("twhlynch")),
}
