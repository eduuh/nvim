package.path = "./lua/?.lua;" .. package.path

local js_package = require("config.js_package")
local original_filereadable = vim.fn.filereadable
local original_readfile = vim.fn.readfile
local original_executable = vim.fn.executable
local original_system = vim.system

local readable = {}
local files = {}
vim.fn.filereadable = function(path)
	return readable[path] and 1 or 0
end
vim.fn.readfile = function(path)
	return files[path] or original_readfile(path)
end

local function lockfile(root, name)
	readable = {}
	files = {}
	if name then
		readable[vim.fs.joinpath(root, name)] = true
	end
end

local root = "/project"

lockfile(root)
assert(js_package.manager(root) == "npm")
assert(vim.deep_equal(js_package.exec(root, "vitest", { "run" }), { "npx", "vitest", "run" }))
assert(vim.deep_equal(js_package.script(root, "test"), { "npm", "run", "test" }))

lockfile(root, "pnpm-lock.yaml")
assert(js_package.manager(root) == "pnpm")
assert(vim.deep_equal(js_package.exec(root, "jest", { "--runInBand" }), { "pnpm", "exec", "jest", "--runInBand" }))
assert(vim.deep_equal(js_package.script(root, "exec"), { "pnpm", "run", "exec" }))

lockfile("/project", "pnpm-lock.yaml")
files["/project/packages/app/package.json"] = { '{"name":"app"}' }
readable["/project/packages/app/package.json"] = true
assert(js_package.manager("/project/packages/app") == "pnpm")

lockfile("/project")
files["/project/package.json"] = { '{"packageManager":"bun@1.2.0"}' }
readable["/project/package.json"] = true
assert(js_package.manager("/project/packages/app") == "bun")
assert(vim.deep_equal(js_package.exec("/project/packages/app", "vitest", { "run" }), { "bun", "x", "vitest", "run" }))
assert(vim.deep_equal(js_package.script("/project/packages/app", "build"), { "bun", "run", "build" }))
local bun_ok, bun_error = pcall(js_package.debug_runtime, "/project/packages/app")
assert(not bun_ok)
assert(bun_error:match("Bun debugging is not supported"))

local captured
vim.fn.executable = function(command)
	return vim.tbl_contains({ "node", "yarn" }, command) and 1 or 0
end
vim.system = function(command, options)
	captured = { command = command, options = options }
	return {
		wait = function()
			return {
				code = 0,
				stdout = "__NVIM_JS_RUNNER__/virtual/tsx/dist/cli.mjs\n",
				stderr = "",
			}
		end,
	}
end

for _, case in ipairs({
	{ lock = "package-lock.json", manager = "npm", command = { "node", "-e" } },
	{ lock = "pnpm-lock.yaml", manager = "pnpm", command = { "node", "-e" } },
	{ lock = "yarn.lock", manager = "yarn", command = { "yarn", "node", "-e" } },
}) do
	lockfile(root, case.lock)
	assert(js_package.resolve_bin(root, "tsx") == "/virtual/tsx/dist/cli.mjs")
	for index, value in ipairs(case.command) do
		assert(captured.command[index] == value)
	end
	assert(captured.command[#captured.command] == "tsx")
	assert(captured.options.cwd == root)
end

lockfile(root, "yarn.lock")
assert(js_package.resolve(root, "vitest/vitest.mjs") == "/virtual/tsx/dist/cli.mjs")
assert(captured.command[1] == "yarn" and captured.command[2] == "node")
local runtime, runtime_args = js_package.debug_runtime(root)
assert(runtime == "yarn" and vim.deep_equal(runtime_args, { "node" }))

local original_root = js_package.root
local original_resolve_bin = js_package.resolve_bin
js_package.root = function()
	return root
end
js_package.resolve_bin = function(resolved_root, package_name)
	assert(resolved_root == root)
	assert(package_name == "tsx")
	return "/virtual/tsx/dist/cli.mjs"
end

for _, manager_case in ipairs({
	{ lock = "package-lock.json", runtime = "node", runtime_args = {} },
	{ lock = "pnpm-lock.yaml", runtime = "node", runtime_args = {} },
	{ lock = "yarn.lock", runtime = "yarn", runtime_args = { "node" } },
}) do
	lockfile(root, manager_case.lock)
	for _, extension in ipairs({ "ts", "tsx", "jsx" }) do
		local context = js_package.debug_context("/project/app." .. extension)
		assert(context.root == root)
		assert(context.runtime == manager_case.runtime)
		assert(vim.deep_equal(context.runtime_args, manager_case.runtime_args))
		assert(context.program == "/virtual/tsx/dist/cli.mjs")
		assert(vim.deep_equal(context.args, { "/project/app." .. extension }))
	end

	local js_context = js_package.debug_context("/project/app.js")
	assert(js_context.runtime == manager_case.runtime)
	assert(vim.deep_equal(js_context.runtime_args, manager_case.runtime_args))
	assert(js_context.program == "/project/app.js")
	assert(vim.deep_equal(js_context.args, {}))
end

js_package.resolve_bin = function()
	error("module not found")
end
lockfile(root, "pnpm-lock.yaml")
local missing_ok, missing_error = pcall(js_package.debug_context, "/project/app.ts")
assert(not missing_ok)
assert(missing_error:match("project%-local tsx is required"))
assert(missing_error:match("pnpm add %-%-save%-dev tsx"))

js_package.root = function()
	error("No package")
end
local standalone = js_package.debug_context("/standalone/drill.js")
assert(standalone.root == "/standalone")
assert(standalone.runtime == "node")
assert(standalone.program == "/standalone/drill.js")
local standalone_ts_ok, standalone_ts_error = pcall(js_package.debug_context, "/standalone/drill.ts")
assert(not standalone_ts_ok)
assert(standalone_ts_error:match("install project%-local tsx"))

js_package.root = original_root
js_package.resolve_bin = original_resolve_bin
vim.fn.filereadable = original_filereadable
vim.fn.readfile = original_readfile
vim.fn.executable = original_executable
vim.system = original_system

print("JS_PACKAGE_MANAGER_OK")
