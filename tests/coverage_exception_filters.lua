package.path = "./lua/?.lua;" .. package.path

local fixture = vim.fs.joinpath(vim.fn.getcwd(), "tests", ".coverage-fixture")
local package_root = vim.fs.joinpath(fixture, "packages", "app")
local source_dir = vim.fs.joinpath(package_root, "src")
vim.fn.mkdir(source_dir, "p")
vim.fn.writefile({ '{"name":"app"}' }, vim.fs.joinpath(package_root, "package.json"))
local source_file = vim.fs.joinpath(source_dir, "index.ts")
vim.fn.writefile({ "export const value = 1" }, source_file)

vim.cmd("edit " .. vim.fn.fnameescape(source_file))
local coverage = require("config.coverage")
assert(coverage.lcov_file() == vim.fs.joinpath(package_root, "coverage", "lcov.info"))

local original_getcwd = vim.fn.getcwd
vim.fn.getcwd = function()
	return package_root
end
local non_package_file = vim.fs.joinpath(fixture, "notes.ts")
vim.fn.writefile({ "export const note = true" }, non_package_file)
vim.cmd("edit " .. vim.fn.fnameescape(non_package_file))
assert(coverage.lcov_file() == vim.fs.joinpath(package_root, "coverage", "lcov.info"))

vim.cmd("enew!")
vim.fn.getcwd = function()
	return fixture
end
assert(coverage.lcov_file() == vim.fs.joinpath(fixture, "coverage", "lcov.info"))
vim.fn.getcwd = original_getcwd

local workflow_specs = dofile("lua/plugins/workflows.lua")
local coverage_opts = workflow_specs[1].opts.lang
assert(type(coverage_opts.javascript.coverage_file) == "function")
assert(coverage_opts.javascript.coverage_file == coverage.lcov_file)
assert(coverage_opts.typescript.coverage_file == coverage.lcov_file)

local specs = dofile("lua/plugins/dap.lua")
local exception_key
for _, key in ipairs(specs[1].keys) do
	if key[1] == ";e" then
		exception_key = key[2]
	end
end
assert(type(exception_key) == "function")

local selected
local configured
local session = {
	capabilities = {
		exceptionBreakpointFilters = {
			{ filter = "raised", label = "Raised exceptions", description = "Break whenever raised", default = true },
			{ filter = "unhandled", label = "Unhandled exceptions", default = false },
			{ filter = "userUnhandled", label = "User-unhandled exceptions", default = true },
		},
	},
}
package.loaded.dap = {
	session = function()
		return session
	end,
	set_exception_breakpoints = function(filters)
		configured = filters
	end,
}
local original_select = vim.ui.select
vim.ui.select = function(items, options, callback)
	selected = { items = items, options = options }
	callback(items[1])
end

exception_key()
assert(selected.options.prompt == "Exception breakpoints")
assert(selected.items[1].label == "Adapter defaults")
assert(vim.deep_equal(selected.items[1].filters, { "raised", "userUnhandled" }))
assert(selected.items[2].label == "Raised exceptions (default)")
assert(selected.items[2].description == "Break whenever raised")
assert(selected.items[#selected.items].label == "Disable exception breaks")
assert(vim.deep_equal(configured, { "raised", "userUnhandled" }))

vim.ui.select = function(items, _, callback)
	callback(items[#items])
end
exception_key()
assert(vim.deep_equal(configured, {}))

vim.ui.select = original_select
package.loaded.dap = nil
vim.cmd("bdelete!")
vim.fn.delete(fixture, "rf")

print("COVERAGE_EXCEPTION_FILTERS_OK")
