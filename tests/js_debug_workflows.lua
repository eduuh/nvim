package.path = "./lua/?.lua;" .. package.path

local jsandts = require("config.dap.jsandts")
local js_package = require("config.js_package")
local js_scripts = require("config.js_scripts")

local dap_runs = {}
local lazy_loads = 0
package.loaded.lazy = {
	load = function(options)
		lazy_loads = lazy_loads + 1
		assert(vim.deep_equal(options.plugins, { "nvim-dap" }))
	end,
}
package.loaded.dap = {
	run = function(config)
		table.insert(dap_runs, config)
	end,
}

local original_debug_context = js_package.debug_context
local original_debug_runtime = js_package.debug_runtime
local original_root = js_package.root
local original_resolve = js_package.resolve
local original_script = js_package.script
local original_select = js_scripts.select
local original_notify = vim.notify
local original_input = vim.ui.input

local notifications = {}
vim.notify = function(message, level)
	table.insert(notifications, { message = message, level = level })
end

js_package.debug_context = function(path)
	assert(path == "/workspace/app.js")
	return {
		root = "/workspace",
		runtime = "node",
		runtime_args = {},
		program = path,
		args = {},
	}
end
local current_file = jsandts.current_file_config("/workspace/app.js")
assert(current_file.type == "pwa-node")
assert(current_file.request == "launch")
assert(current_file.program == "/workspace/app.js")
assert(current_file.cwd == "/workspace")
assert(current_file.runtimeExecutable == "node")
assert(vim.deep_equal(current_file.runtimeArgs, {}))
assert(current_file.sourceMaps and current_file.smartStep)
assert(current_file.resolveSourceMapLocations[1] == "/workspace/**")

js_package.root = function(path)
	assert(path == "")
	return "/workspace"
end
local browser_launch = jsandts.browser_launch_config("http://localhost:4173")
assert(browser_launch.type == "pwa-chrome")
assert(browser_launch.request == "launch")
assert(browser_launch.url == "http://localhost:4173")
assert(browser_launch.webRoot() == "/workspace")
assert(browser_launch.sourceMaps == true)
js_package.root = original_root

local original_input_fn = vim.fn.input
vim.fn.input = function(prompt, default)
	assert(prompt:match("Rsbuild dev server URL"))
	assert(default == "http://localhost:3000")
	return "http://localhost:5173"
end
assert(jsandts.dev_server_url() == "http://localhost:5173")
vim.fn.input = original_input_fn

js_package.debug_context = function(path)
	return {
		root = "/workspace",
		runtime = "yarn",
		runtime_args = { "node" },
		program = "/virtual/tsx/dist/cli.mjs",
		args = { path },
	}
end
for _, extension in ipairs({ "ts", "tsx", "jsx" }) do
	local path = "/workspace/app." .. extension
	local config = jsandts.current_file_config(path)
	assert(config.runtimeExecutable == "yarn")
	assert(vim.deep_equal(config.runtimeArgs, { "node" }))
	assert(config.program == "/virtual/tsx/dist/cli.mjs")
	assert(vim.deep_equal(config.args, { path }))
	assert(config.cwd == "/workspace")
end

js_package.debug_context = function()
	error("project-local tsx is required; run `pnpm add --save-dev tsx`")
end
local runs_before = #dap_runs
local loads_before = lazy_loads
jsandts.debug_current_file()
assert(#dap_runs == runs_before)
assert(lazy_loads == loads_before)
assert(notifications[#notifications].message:match("project%-local tsx"))
assert(notifications[#notifications].level == vim.log.levels.ERROR)

js_package.debug_context = function()
	error("Bun debugging is not supported by the installed js-debug adapter")
end
jsandts.debug_current_file()
assert(#dap_runs == runs_before)
assert(lazy_loads == loads_before)
assert(notifications[#notifications].message:match("Bun debugging is not supported"))

js_package.debug_runtime = function(root)
	if root == "/bun" then
		error("Bun debugging is not supported by the installed js-debug adapter")
	end
	return "node"
end
js_package.script = function(root, script)
	return { root == "/yarn" and "yarn" or "npm", "run", script }
end
local script = jsandts.package_script_config("/workspace", "test")
assert(script.runtimeExecutable == "npm")
assert(vim.deep_equal(script.runtimeArgs, { "run", "test" }))
assert(script.cwd == "/workspace")

js_scripts.select = function(prompt, callback)
	assert(prompt == "Debug package script")
	callback("/bun", "dev")
end
js_scripts.debug_pick()
assert(#dap_runs == runs_before)
assert(lazy_loads == loads_before)
assert(notifications[#notifications].message:match("Bun debugging is not supported"))

js_scripts.select = function(_, callback)
	callback("/workspace", "dev")
end
js_scripts.debug_pick()
assert(#dap_runs == runs_before + 1)
assert(dap_runs[#dap_runs].name == "Debug package script: dev")

local input_options
vim.ui.input = function(options, callback)
	input_options = options
	callback(options.default)
end
jsandts.attach_browser()
assert(input_options.default == "9222")
assert(dap_runs[#dap_runs].port == 9222)

vim.ui.input = function(_, callback)
	callback("invalid")
end
jsandts.attach_browser()
assert(notifications[#notifications].message:match("integer"))

package.loaded.dap = {
	configurations = {},
}
package.loaded["dap.utils"] = {
	pick_process = function() end,
}
js_package.debug_context = original_debug_context
js_package.debug_runtime = function()
	return "node", {}
end
js_package.root = function()
	return "/workspace"
end
js_package.resolve = function(_, request)
	return "/virtual/" .. request
end
jsandts.setup_if_no_vscode_config()
local configs = package.loaded.dap.configurations.javascript
assert(configs[1].name == "Debug current file")
assert(type(getmetatable(configs[1]).__call) == "function")
assert(configs[2].name == "Launch browser for dev server")
assert(type(configs[2].url) == "function")
assert(type(configs[2].webRoot) == "function")
local jest = vim.iter(configs):find(function(config)
	return type(config) == "table" and config.name == "Debug Jest Tests"
end)
local vitest = vim.iter(configs):find(function(config)
	return type(config) == "table" and config.name == "Debug current Vitest file"
end)
assert(jest and vitest)
assert(type(jest.runtimeExecutable) == "function")
assert(type(vitest.runtimeExecutable) == "function")
assert(jest.runtimeExecutable() == "node")
assert(vitest.runtimeExecutable() == "node")

js_package.debug_context = original_debug_context
js_package.debug_runtime = original_debug_runtime
js_package.root = original_root
js_package.resolve = original_resolve
js_package.script = original_script
js_scripts.select = original_select
vim.notify = original_notify
vim.ui.input = original_input

print("JS_DEBUG_WORKFLOWS_OK")
