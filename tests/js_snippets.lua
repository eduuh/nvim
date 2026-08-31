vim.cmd.packadd("LuaSnip")
package.path = "./lua/?.lua;" .. package.path
require("config.snippets").setup()
local ls = require("luasnip")

local function by_trigger(snippets)
	local result = {}
	for _, snippet in ipairs(snippets) do
		result[snippet.trigger] = snippet
	end
	return result
end

local function expand_loaded(trigger, filetype, filename)
	vim.cmd("enew!")
	vim.api.nvim_buf_set_name(0, filename)
	vim.bo.filetype = filetype
	require("luasnip.loaders").load_lazy_loaded(0)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { trigger .. " " })
	vim.api.nvim_win_set_cursor(0, { 1, #trigger })
	assert(ls.expandable(), ("configured LuaSnip loader did not expose %s in %s"):format(trigger, filetype))
	assert(ls.expand(), ("configured LuaSnip loader did not expand %s in %s"):format(trigger, filetype))
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	ls.unlink_current()
	return text
end

for _, check in ipairs({
	{ "promiseall", "javascript", "loader.js", "await Promise.all" },
	{ "promiseall", "javascriptreact", "loader.jsx", "await Promise.all" },
	{ "promiseall", "typescript", "loader.ts", "await Promise.all" },
	{ "promiseall", "typescriptreact", "loader.tsx", "await Promise.all" },
	{ "interface", "typescript", "loader-interface.ts", "interface Name" },
	{ "interface", "typescriptreact", "loader-interface.tsx", "interface Name" },
}) do
	assert(expand_loaded(check[1], check[2], check[3]):find(check[4], 1, true))
end

local javascript = by_trigger(dofile("snippets/javascript.lua"))
local typescript = by_trigger(dofile("snippets/typescript.lua"))

for _, trigger in ipairs({ "promiseall", "allsettled", "abortctl", "resolves", "rejects" }) do
	assert(javascript[trigger], "missing shared async snippet " .. trigger)
end
for _, trigger in ipairs({ "wsclient", "wswatch", "wssend", "wsserver", "wsserversend" }) do
	assert(javascript[trigger], "missing WebSocket snippet " .. trigger)
end
for _, trigger in ipairs({ "interface", "type", "enum", "asconst", "satisfies", "typeguard" }) do
	assert(typescript[trigger], "missing TypeScript snippet " .. trigger)
	assert(not javascript[trigger], "TypeScript-only snippet leaked into JavaScript: " .. trigger)
end

local function expand(snippet, filetype, filename)
	vim.cmd("enew!")
	vim.bo.filetype = filetype
	vim.api.nvim_buf_set_name(0, filename)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	ls.snip_expand(snippet)
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	ls.unlink_current()
	return text
end

local interface = expand(typescript.interface, "typescript", "model.ts")
assert(interface:match("interface Name"))
assert(interface:match("property: string"))

local promiseall = expand(javascript.promiseall, "javascriptreact", "component.jsx")
assert(promiseall:match("await Promise%.all"))
assert(promiseall:match("firstPromise"))

local expansion_checks = {
	{ typescript.type, "typescript", "type.ts", "type Name" },
	{ typescript.enum, "typescript", "enum.ts", "enum Name" },
	{ typescript.asconst, "typescript", "asconst.ts", "as const" },
	{ typescript.satisfies, "typescript", "satisfies.ts", "satisfies Type" },
	{ typescript.typeguard, "typescriptreact", "guard.tsx", "value is Type" },
	{ javascript.allsettled, "javascript", "settled.js", "Promise.allSettled" },
	{ javascript.abortctl, "typescript", "abort.ts", "AbortController" },
	{ javascript.resolves, "javascriptreact", "resolve.jsx", "resolves.toEqual" },
	{ javascript.rejects, "typescriptreact", "reject.tsx", "rejects.toThrow" },
}
for _, check in ipairs(expansion_checks) do
	assert(expand(check[1], check[2], check[3]):find(check[4], 1, true))
end

local wsclient = expand(javascript.wsclient, "javascript", "client.js")
assert(wsclient:match("%[client%.js%] WebSocket client traffic"))
assert(wsclient:match('direction: "inbound"'))
assert(wsclient:match('direction: "error"'))

local wssend = expand(javascript.wssend, "javascriptreact", "send.jsx")
assert(wssend:match("%[send%.jsx%] WebSocket client traffic"))
assert(wssend:match('direction: "outbound"'))

local wswatch = expand(javascript.wswatch, "typescript", "watch.ts")
assert(wswatch:match("%[watch%.ts%] WebSocket client traffic"))
assert(wswatch:match('direction: "inbound"'))
assert(wswatch:match('direction: "connected"'))
assert(wswatch:match('direction: "error"'))

local wsserver = expand(javascript.wsserver, "typescriptreact", "socket.tsx")
assert(wsserver:match("%[socket%.tsx%] WebSocket server traffic"))
assert(wsserver:match('direction: "inbound"'))
assert(wsserver:match('direction: "error"'))
assert(wsserver:match("readyState"))
assert(wsserver:match("new Date%(%)%.toISOString%(%)"))
assert(not wsserver:match('from "ws"'))

local wsserversend = expand(javascript.wsserversend, "javascript", "server-send.js")
assert(wsserversend:match("%[server%-send%.js%] WebSocket server traffic"))
assert(wsserversend:match('direction: "outbound"'))
assert(wsserversend:match("readyState"))

print("JS_SNIPPETS_OK")
