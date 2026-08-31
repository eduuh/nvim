local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix
local rep = require("luasnip.extras").rep
local treesitter_postfix = require("luasnip.extras.treesitter_postfix")
local tspostfix = treesitter_postfix.treesitter_postfix
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local postfix_match_pattern = [[[%w%._%-%[%]%(%)"'%?]+$]]

local function postfix_context(trigger)
	return {
		trig = trigger,
		match_pattern = postfix_match_pattern,
	}
end

local function postfix_match(_, parent)
	return parent.snippet.env.POSTFIX_MATCH
end

local function file_name()
	local name = vim.fn.expand("%:t")
	return name ~= "" and name or "[No Name]"
end

local function debug_label(description)
	return ("[%s] %s"):format(file_name(), description)
end

local function label_node(description)
	return f(function()
		return vim.json.encode(debug_label(description))
	end)
end

local function filename_node()
	return f(file_name)
end

local function enclosing_function_name(row)
	for index = row, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, index - 1, index, false)[1]
		local name = line and line:match("function%s+([%w_$]+)")
		if name then
			return name
		end
	end
	return "result"
end

local function return_statement(_, parent)
	local lines = vim.deepcopy(parent.env.LS_TSMATCH)
	local indent = lines[1]:match("^([ \t]*)") or ""
	lines[1] = lines[1]:gsub("^%s*return%s+", "", 1)
	lines[#lines] = lines[#lines]:gsub(";%s*$", "", 1)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local label = debug_label("Return " .. enclosing_function_name(row))

	return sn(nil, {
		t(indent .. "const "),
		i(1, "result"),
		t(" = "),
		t(lines),
		t({ ";", indent .. ('console.log("%s", '):format(label) }),
		rep(1),
		t({ ");", indent .. "return " }),
		rep(1),
		t(";"),
	})
end

return {
	tspostfix({
		trig = ".LogR",
		priority = 2000,
		reparseBuffer = "copy",
		matchTSNode = treesitter_postfix.builtin.tsnode_matcher.find_first_types("return_statement"),
	}, {
		d(1, return_statement),
	}),
	postfix(postfix_context(".Log"), {
		f(function(_, parent)
			local match = parent.snippet.env.POSTFIX_MATCH
			return ("console.log(%s, %s);"):format(vim.json.encode(debug_label("Value " .. match)), match)
		end),
	}),
	postfix(postfix_context(".Logs"), {
		f(function(_, parent)
			local match = parent.snippet.env.POSTFIX_MATCH
			return ("console.log(%s, JSON.stringify(%s, null, 2));"):format(
				vim.json.encode(debug_label("JSON " .. match)),
				match
			)
		end),
	}),
	postfix(postfix_context(".Table"), {
		f(function(_, parent)
			local match = parent.snippet.env.POSTFIX_MATCH
			return {
				("console.log(%s);"):format(vim.json.encode(debug_label("Table " .. match))),
				("console.table(%s);"):format(match),
			}
		end),
	}),
	postfix(postfix_context(".Dir"), {
		f(function(_, parent)
			local match = parent.snippet.env.POSTFIX_MATCH
			return {
				("console.log(%s);"):format(vim.json.encode(debug_label("Inspect " .. match))),
				("console.dir(%s, { depth: null, colors: true });"):format(match),
			}
		end),
	}),
	postfix(postfix_context(".Assert"), {
		t("console.assert("),
		d(1, function(_, parent)
			return sn(nil, {
				i(1, parent.env.POSTFIX_MATCH),
			})
		end),
		t(", "),
		label_node("Assertion failed"),
		t(", "),
		f(postfix_match),
		t(");"),
	}),
	postfix(postfix_context(".Await"), {
		t("const "),
		i(1, "result"),
		t(" = await "),
		f(postfix_match),
		t(";"),
	}),
	postfix(postfix_context(".Return"), {
		f(function(_, parent)
			return ("return %s;"):format(parent.snippet.env.POSTFIX_MATCH)
		end),
	}),
	postfix(postfix_context(".Catch"), {
		f(postfix_match),
		t({ ".catch((error) => {", "\tconsole.error(" }),
		label_node("Promise rejected"),
		t({ ", error);", "\tthrow error;", "});" }),
	}),
	s(
		"af",
		fmt("const {} = ({}) => {{\n\t{}\n}};", {
			i(1, "name"),
			i(2),
			i(0),
		})
	),
	s(
		"fn",
		fmt("function {}({}) {{\n\t{}\n}}", {
			i(1, "name"),
			i(2),
			i(0),
		})
	),
	s(
		"imp",
		fmt('import {{ {} }} from "{}";', {
			i(1),
			i(2, "module"),
		})
	),
	s(
		"log",
		fmt("console.log({}, {});", {
			label_node("Value"),
			i(0),
		})
	),
	s(
		"desc",
		fmt('describe("{}", () => {{\n\t{}\n}});', {
			i(1, "suite"),
			i(0),
		})
	),
	s(
		"it",
		fmt('it("{}", () => {{\n\t{}\n}});', {
			i(1, "does something"),
			i(0),
		})
	),
	s("try", {
		t({ "try {", "\t" }),
		i(1),
		t({ "", "} catch (error) {", "\t" }),
		i(0, "throw error;"),
		t({ "", "}" }),
	}),
	s(
		"guard",
		fmt("if (!{}) {{\n\treturn {};\n}}", {
			i(1, "condition"),
			i(0),
		})
	),
	s(
		"trya",
		fmt("try {{\n\t{}\n}} catch (error) {{\n\tconsole.error({}, error);\n\t{}\n}}", {
			i(1, "await operation();"),
			label_node("Async operation failed"),
			i(0, "throw error;"),
		})
	),
	s(
		"fetchj",
		fmt(
			[[const response = await fetch({});
if (!response.ok) {{
	throw new Error(`${{response.status}} ${{response.statusText}}`);
}}
const data = await response.json();
{}]],
			{
				i(1, "url"),
				i(0),
			}
		)
	),
	s(
		"promiseall",
		fmt("const [{}] = await Promise.all([{}]);\n{}", {
			i(1, "first, second"),
			i(2, "firstPromise, secondPromise"),
			i(0),
		})
	),
	s(
		"allsettled",
		fmt("const {} = await Promise.allSettled([{}]);\n{}", {
			i(1, "results"),
			i(2, "firstPromise, secondPromise"),
			i(0),
		})
	),
	s(
		"abortctl",
		fmt(
			[[const {} = new AbortController();
const {{ signal }} = {};

{}]],
			{
				i(1, "controller"),
				rep(1),
				i(0),
			}
		)
	),
	s(
		"resolves",
		fmt("await expect({}).resolves.toEqual({});", {
			i(1, "promise"),
			i(0, "expected"),
		})
	),
	s(
		"rejects",
		fmt("await expect({}).rejects.toThrow({});", {
			i(1, "promise"),
			i(0, "expectedError"),
		})
	),
	s(
		"bench",
		fmt(
			[[const startedAt = performance.now();
{}
console.log({}, performance.now() - startedAt);]],
			{
				i(0),
				label_node("Duration (ms)"),
			}
		)
	),
	s("dbg", {
		t("debugger;"),
	}),
	s(
		"trace",
		fmt("console.trace({});", {
			label_node("Stack trace"),
		})
	),
	s("timer", {
		t('console.time("['),
		filename_node(),
		t("] "),
		i(1, "operation"),
		t({ '");', "" }),
		i(0),
		t({ "", 'console.timeEnd("[' }),
		filename_node(),
		t("] "),
		rep(1),
		t('");'),
	}),
	s(
		"wsclient",
		fmt(
			[[const {} = new WebSocket({});

{}.addEventListener("open", () => console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "connected",
	payload: {}.url,
}}));
{}.addEventListener("message", (event) => console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "inbound",
	payload: event.data,
}}));
{}.addEventListener("error", (error) => console.error({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "error",
	payload: error,
}}));
{}.addEventListener("close", (event) => {{
	console.log({}, {{
		timestamp: new Date().toISOString(),
		readyState: {}.readyState,
		direction: "closed",
		code: event.code,
		reason: event.reason,
	}});
}});

{}]],
			{
				i(1, "socket"),
				i(2, '"ws://localhost:8080"'),
				rep(1),
				label_node("WebSocket client state"),
				rep(1),
				rep(1),
				rep(1),
				label_node("WebSocket client traffic"),
				rep(1),
				rep(1),
				label_node("WebSocket client error"),
				rep(1),
				rep(1),
				label_node("WebSocket client state"),
				rep(1),
				i(0),
			}
		)
	),
	s(
		"wswatch",
		fmt(
			[[{}.addEventListener("open", () => console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "connected",
	payload: {}.url,
}}));
{}.addEventListener("message", (event) => console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "inbound",
	payload: event.data,
}}));
{}.addEventListener("error", (error) => console.error({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "error",
	payload: error,
}}));
{}.addEventListener("close", (event) => {{
	console.log({}, {{
		timestamp: new Date().toISOString(),
		readyState: {}.readyState,
		direction: "closed",
		code: event.code,
		reason: event.reason,
	}});
}});]],
			{
				i(1, "socket"),
				label_node("WebSocket client state"),
				rep(1),
				rep(1),
				rep(1),
				label_node("WebSocket client traffic"),
				rep(1),
				rep(1),
				label_node("WebSocket client error"),
				rep(1),
				rep(1),
				label_node("WebSocket client state"),
				rep(1),
			}
		)
	),
	s(
		"wssend",
		fmt(
			[[const {} = {{
	type: "{}",
	payload: {},
}};
console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "outbound",
	payload: {},
}});
{}.send(JSON.stringify({}));]],
			{
				i(1, "message"),
				i(2, "message"),
				i(3, "{}"),
				label_node("WebSocket client traffic"),
				i(4, "socket"),
				rep(1),
				rep(4),
				rep(1),
			}
		)
	),
	s(
		"wsserver",
		fmt(
			[[{}.on("connection", (socket, request) => {{
	console.log({}, {{
		timestamp: new Date().toISOString(),
		readyState: socket.readyState,
		direction: "connected",
		payload: request.socket.remoteAddress,
	}});
	socket.on("message", (data, isBinary) => {{
		console.log({}, {{
			timestamp: new Date().toISOString(),
			readyState: socket.readyState,
			direction: "inbound",
			payload: isBinary ? data : data.toString(),
		}});
	}});
	socket.on("error", (error) => console.error({}, {{
		timestamp: new Date().toISOString(),
		readyState: socket.readyState,
		direction: "error",
		payload: error,
	}}));
	socket.on("close", (code, reason) => {{
		console.log({}, {{
			timestamp: new Date().toISOString(),
			readyState: socket.readyState,
			direction: "closed",
			code,
			reason: reason.toString(),
		}});
	}});
	{}
}});]],
			{
				i(1, "server"),
				label_node("WebSocket server state"),
				label_node("WebSocket server traffic"),
				label_node("WebSocket server error"),
				label_node("WebSocket server state"),
				i(0),
			}
		)
	),
	s(
		"wsserversend",
		fmt(
			[[console.log({}, {{
	timestamp: new Date().toISOString(),
	readyState: {}.readyState,
	direction: "outbound",
	payload: {},
}});
{}.send({});]],
			{
				label_node("WebSocket server traffic"),
				i(1, "socket"),
				i(2, "payload"),
				rep(1),
				rep(2),
			}
		)
	),
	s(
		"eventlag",
		fmt(
			[[import {{ monitorEventLoopDelay }} from "node:perf_hooks";

const eventLoopDelay = monitorEventLoopDelay({{ resolution: {} }});
eventLoopDelay.enable();

setInterval(() => {{
	console.log({}, {{
		mean: eventLoopDelay.mean / 1e6,
		max: eventLoopDelay.max / 1e6,
		p99: eventLoopDelay.percentile(99) / 1e6,
	}});
	eventLoopDelay.reset();
}}, {});]],
			{
				i(1, "20"),
				label_node("Event loop delay (ms)"),
				i(0, "1000"),
			}
		)
	),
	s(
		"asynctrace",
		fmt(
			[[import {{ createHook }} from "node:async_hooks";
import {{ writeSync }} from "node:fs";

		const asyncTraceLabel = {};

		createHook({{
			init(asyncId, type, triggerAsyncId) {{
				writeSync(1, `${{asyncTraceLabel}} created ${{asyncId}} ${{type}} <- ${{triggerAsyncId}}\n`);
			}},
			destroy(asyncId) {{
				writeSync(1, `${{asyncTraceLabel}} destroyed ${{asyncId}}\n`);
			}},
		}}).enable();

		{}]],
			{
				label_node("Async resource"),
				i(0),
			}
		)
	),
	s("uxmark", {
		t('data-debug="'),
		i(1, "component-name"),
		t('" style={{ outline: "2px solid '),
		i(2, "#ff006e"),
		t('", backgroundColor: "'),
		i(3, "rgba(255, 0, 110, 0.08)"),
		t('" }}'),
	}),
}
