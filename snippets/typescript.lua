local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local i = ls.insert_node
local s = ls.snippet

return {
	s(
		"interface",
		fmt(
			[[interface {} {{
	{}: {};
	{}
}}]],
			{
				i(1, "Name"),
				i(2, "property"),
				i(3, "string"),
				i(0),
			}
		)
	),
	s(
		"type",
		fmt(
			[[type {} = {{
	{}: {};
	{}
}};]],
			{
				i(1, "Name"),
				i(2, "property"),
				i(3, "string"),
				i(0),
			}
		)
	),
	s(
		"enum",
		fmt(
			[[enum {} {{
	{} = "{}",
	{}
}}]],
			{
				i(1, "Name"),
				i(2, "Member"),
				i(3, "member"),
				i(0),
			}
		)
	),
	s(
		"asconst",
		fmt(
			[[const {} = {{
	{}: {},
}} as const;
{}]],
			{
				i(1, "value"),
				i(2, "key"),
				i(3, '"value"'),
				i(0),
			}
		)
	),
	s(
		"satisfies",
		fmt(
			[[const {} = {{
	{}: {},
}} satisfies {};
{}]],
			{
				i(1, "value"),
				i(2, "key"),
				i(3, '"value"'),
				i(4, "Type"),
				i(0),
			}
		)
	),
	s(
		"typeguard",
		fmt(
			[[function is{}({}: unknown): {} is {} {{
	return {};
}}]],
			{
				i(1, "Type"),
				i(2, "value"),
				rep(2),
				rep(1),
				i(0, 'typeof value === "object" && value !== null'),
			}
		)
	),
}
