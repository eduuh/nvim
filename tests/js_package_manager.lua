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
assert(vim.deep_equal(js_package.exec("/project/packages/app", "vitest", { "run" }), { "pnpm", "exec", "vitest", "run" }))

lockfile("/project")
files["/project/package.json"] = { '{"packageManager":"bun@1.2.0"}' }
readable["/project/package.json"] = true
assert(js_package.manager("/project/packages/app") == "bun")
assert(vim.deep_equal(js_package.exec("/project/packages/app", "vitest", { "run" }), { "bun", "x", "vitest", "run" }))
assert(vim.deep_equal(js_package.script("/project/packages/app", "build"), { "bun", "run", "build" }))
local bun_runtime, bun_args = js_package.debug_runtime("/project/packages/app")
assert(bun_runtime == "bun" and bun_args == nil)

local captured
lockfile(root, "yarn.lock")
assert(vim.deep_equal(js_package.exec(root, "vitest", { "run" }), { "yarn", "exec", "vitest", "run" }))
assert(vim.deep_equal(js_package.script(root, "exec"), { "yarn", "run", "exec" }))
vim.fn.executable = function(command)
	return command == "yarn" and 1 or 0
end
vim.system = function(command, options)
	captured = { command = command, options = options }
	return {
		wait = function()
			return {
				code = 0,
				stdout = "yarn node v1.22.0\n__NVIM_JS_RUNNER__/virtual/vitest.mjs\nDone\n",
				stderr = "",
			}
		end,
	}
end

assert(js_package.resolve(root, "vitest/vitest.mjs") == "/virtual/vitest.mjs")
assert(captured.command[1] == "yarn" and captured.command[2] == "node")
assert(captured.command[#captured.command] == "vitest/vitest.mjs")
assert(captured.options.cwd == root)
local runtime, runtime_args = js_package.debug_runtime(root)
assert(runtime == "yarn" and vim.deep_equal(runtime_args, { "node" }))

vim.fn.filereadable = original_filereadable
vim.fn.readfile = original_readfile
vim.fn.executable = original_executable
vim.system = original_system

print("JS_PACKAGE_MANAGER_OK")
