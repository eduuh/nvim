package.path = "./lua/?.lua;" .. package.path

local js_tests = require("config.js_tests")

local function source_line(source, text)
	for line, value in ipairs(vim.split(source, "\n", { plain = true })) do
		if value:find(text, 1, true) then
			return line
		end
	end
	error("Could not find source line containing " .. text)
end

local function buffer_line(text)
	for line, value in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		if value:find(text, 1, true) then
			return line
		end
	end
	error("Could not find buffer line containing " .. text)
end

local function nearest(source, declaration)
	vim.cmd("enew!")
	vim.bo.filetype = "typescript"
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(source, "\n", { plain = true }))
	vim.api.nvim_win_set_cursor(0, { source_line(source, declaration), 0 })
	return js_tests.nearest_test_name()
end

local multiline = [[
describe("suite", () => {
  test(
    "runs across lines",
    () => {
      expect(true).toBe(true)
    }
  )

  it.only(
    `watches and debugs across lines`,
    () => {
      expect(true).toBe(true)
    }
  )
})]]

assert(nearest(multiline, "runs across lines") == "runs across lines")
assert(nearest(multiline, "watches and debugs across lines") == "watches and debugs across lines")

package.loaded.dap = {
	configurations = {},
}
package.loaded["dap.utils"] = {
	pick_process = function() end,
}
local jsandts = require("config.dap.jsandts")
jsandts.setup_if_no_vscode_config()
local configs = package.loaded.dap.configurations.javascript
local jest = vim.iter(configs):find(function(config)
	return type(config) == "table" and config.name == "Debug Jest Tests"
end)
local vitest = vim.iter(configs):find(function(config)
	return type(config) == "table" and config.name == "Debug current Vitest file"
end)
assert(type(jest.cwd) == "function")
assert(type(jest.runtimeExecutable) == "function")
assert(type(jest.runtimeArgs) == "function")
assert(type(vitest.cwd) == "function")
assert(type(vitest.runtimeExecutable) == "function")
assert(type(vitest.runtimeArgs) == "function")
assert(type(vitest.program) == "function")

local js_package = require("config.js_package")
local original_root = js_package.root
local original_resolve = js_package.resolve
local original_debug_runtime = js_package.debug_runtime
js_package.root = function()
	return "/workspace/packages/app"
end
js_package.resolve = function(root, request)
	assert(root == "/workspace/packages/app")
	return "/virtual/" .. request
end
js_package.debug_runtime = function(root)
	assert(root == "/workspace/packages/app")
	return "yarn", { "node" }
end
assert(jest.cwd() == "/workspace/packages/app")
assert(jest.runtimeExecutable() == "yarn")
assert(vim.deep_equal(jest.runtimeArgs(), { "node" }))
assert(jest.program() == "/virtual/jest/bin/jest")
assert(vitest.cwd() == "/workspace/packages/app")
assert(vitest.runtimeExecutable() == "yarn")
assert(vim.deep_equal(vitest.runtimeArgs(), { "node" }))
assert(vitest.program() == "/virtual/vitest/vitest.mjs")
js_package.root = original_root
js_package.resolve = original_resolve
js_package.debug_runtime = original_debug_runtime

local fixture = vim.fs.joinpath(vim.fn.getcwd(), "tests", ".js-workflows-fixture")
local package_root = vim.fs.joinpath(fixture, "packages", "app")
local original_jobwait = vim.fn.jobwait
local original_notify = vim.notify
local test_file = vim.fs.joinpath(package_root, "multiline.test.ts")

local ok, error_message = xpcall(function()
	vim.fn.mkdir(package_root, "p")
	vim.fn.writefile({}, vim.fs.joinpath(fixture, "pnpm-lock.yaml"))
	vim.fn.writefile({ '{"devDependencies":{"vitest":"1.0.0"}}' }, vim.fs.joinpath(package_root, "package.json"))
	vim.fn.writefile(vim.split(multiline, "\n", { plain = true }), test_file)
	vim.cmd("edit " .. vim.fn.fnameescape(test_file))
	vim.api.nvim_win_set_cursor(0, { buffer_line("watches and debugs across lines"), 0 })

	local terminals = {}
	local running_jobs = {}
	local next_job_id = 100
	vim.fn.jobwait = function(job_ids, timeout)
		assert(timeout == 0)
		return { running_jobs[job_ids[1]] and -1 or 0 }
	end
	package.loaded.lazy = { load = function() end }
	package.loaded["toggleterm.terminal"] = {
		Terminal = {
			new = function(_, options)
				next_job_id = next_job_id + 1
				local terminal = {
					options = options,
					job_id = next_job_id,
					toggle = function() end,
					send = function(self, input)
						self.sent = input
						self.send_count = (self.send_count or 0) + 1
					end,
					shutdown = function(self)
						self.shutdown_count = (self.shutdown_count or 0) + 1
						running_jobs[self.job_id] = false
						self.options.on_exit(self, self.job_id, 0)
					end,
				}
				running_jobs[terminal.job_id] = true
				table.insert(terminals, terminal)
				return terminal
			end,
		},
	}

	js_tests.run_nearest()
	assert(terminals[#terminals].options.cmd:match("pnpm"))
	assert(terminals[#terminals].options.cmd:match("watches and debugs across lines"))
	assert(terminals[#terminals].options.dir == package_root)
	js_tests.watch_nearest()
	assert(terminals[#terminals].options.cmd:match("watches and debugs across lines"))
	local replaced_watch = terminals[#terminals]
	js_tests.watch_file()
	assert(replaced_watch.shutdown_count == 1)
	local active_watch = terminals[#terminals]
	assert(active_watch ~= replaced_watch)

	vim.cmd("enew!")
	js_package.root = function()
		error("rerun_failed resolved context before checking the active watcher")
	end
	js_tests.rerun_failed()
	assert(active_watch.sent == "f")
	assert(active_watch.send_count == 1)
	js_package.root = original_root

	running_jobs[active_watch.job_id] = false
	local notification
	vim.notify = function(message, level)
		notification = { message = message, level = level }
	end
	js_package.root = function()
		error("outside a JavaScript package")
	end
	local rerun_ok, rerun_error = pcall(js_tests.rerun_failed)
	assert(rerun_ok, rerun_error)
	assert(active_watch.sent == "f")
	assert(active_watch.send_count == 1)
	assert(notification and notification.message:match("watch mode"))
	assert(notification.level == vim.log.levels.INFO)
	active_watch.options.on_exit(active_watch, active_watch.job_id, 0)
	assert(active_watch.js_test_watch_alive == false)
	vim.notify = original_notify
	js_package.root = original_root
	vim.cmd("edit " .. vim.fn.fnameescape(test_file))
	vim.api.nvim_win_set_cursor(0, { buffer_line("watches and debugs across lines"), 0 })

	local special_name = "matches (groups) [items] \\ paths .*+?^${}|"
	local escaped_name = "matches \\(groups\\) \\[items\\] \\\\ paths \\.\\*\\+\\?\\^\\$\\{\\}\\|"
	js_tests.nearest_test_name = function()
		return special_name
	end

	js_tests.run_nearest()
	assert(terminals[#terminals].options.cmd:find(vim.fn.shellescape(escaped_name), 1, true))
	js_tests.watch_nearest()
	assert(terminals[#terminals].options.cmd:find(vim.fn.shellescape(escaped_name), 1, true))

	local debug_config
	package.loaded.dap.run = function(config)
		debug_config = config
	end
	js_package.resolve = function(_, request)
		return "/virtual/" .. request
	end
	js_tests.debug_nearest()
	assert(debug_config.program == "/virtual/vitest/vitest.mjs")
	assert(vim.tbl_contains(debug_config.args, escaped_name))

	vim.fn.writefile({ '{"devDependencies":{"jest":"1.0.0"}}' }, vim.fs.joinpath(package_root, "package.json"))
	js_tests.run_nearest()
	assert(terminals[#terminals].options.cmd:find("jest", 1, true))
	assert(terminals[#terminals].options.cmd:find(vim.fn.shellescape(escaped_name), 1, true))
	js_tests.watch_nearest()
	assert(terminals[#terminals].options.cmd:find("--watch", 1, true))
	assert(terminals[#terminals].options.cmd:find(vim.fn.shellescape(escaped_name), 1, true))
	js_tests.debug_nearest()
	assert(debug_config.program == "/virtual/jest/bin/jest")
	assert(vim.tbl_contains(debug_config.args, escaped_name))
	-- Coverage instrumentation breaks breakpoint line mapping, so a debug run
	-- must always turn it off.
	assert(vim.tbl_contains(debug_config.args, "--coverage=false"))
end, debug.traceback)

js_package.root = original_root
js_package.resolve = original_resolve
vim.fn.jobwait = original_jobwait
vim.notify = original_notify
pcall(vim.cmd, "bdelete!")
vim.fn.delete(fixture, "rf")
assert(ok, error_message)

print("JS_WORKFLOWS_OK")
