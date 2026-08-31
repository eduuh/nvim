package.path = "./lua/?.lua;" .. package.path

local startup_profile = require("config.startup_profile")
local summary = startup_profile.summarize({
	"000.010  000.010: --- NVIM STARTING ---",
	"004.000  003.990: loading Lua",
	"014.500  010.500  006.500: sourcing /config/init.lua",
	"015.000  000.500: finished",
})

assert(summary[1] == "Startup total: 15.00 ms")
assert(summary[2] == "Slowest startup entries (self time):")
assert(summary[3]:match("6%.50 ms"))
assert(summary[3]:match("sourcing /config/init%.lua"))
assert(summary[4]:match("3%.99 ms"))
startup_profile.setup()
assert(vim.fn.exists(":StartupProfile") == 2)
assert(not vim.loader or type(vim.loader.enable) == "function")

local report_pattern = vim.fs.joinpath(vim.fn.stdpath("state"), "startup-profile-*.log")
local function report_count()
	return #vim.fn.glob(report_pattern, false, true)
end

local before = report_count()
local async_result = vim.system({ vim.v.progpath, "--headless", "+StartupProfile", "+qa" }, { text = true }):wait()
assert(async_result.code == 0, async_result.stderr)
vim.wait(1000, function()
	return report_count() ~= before
end)
assert(report_count() == before, "asynchronous StartupProfile leaked a report during exit")

local original_system = vim.system
local original_schedule = vim.schedule
local original_notify = vim.notify
local scheduled
local completed
local process = { kill_count = 0, wait_count = 0 }
function process:kill()
	self.kill_count = self.kill_count + 1
end
function process:wait()
	self.wait_count = self.wait_count + 1
end

local race_ok, race_error = xpcall(function()
	vim.schedule = function(callback)
		assert(not scheduled, "scheduled completion was registered twice")
		scheduled = callback
	end
	vim.system = function(command, _, callback)
		completed = callback
		vim.fn.writefile({ "001.000  001.000: completed child" }, command[4])
		return process
	end
	vim.notify = function() end

	startup_profile.run({ bang = false })
	assert(completed, "profile process completion callback was not captured")
	completed({ code = 0, stdout = "", stderr = "" })
	assert(scheduled, "profile completion was not scheduled")
	assert(report_count() == before + 1, "completed profile report was not pending")
	vim.schedule = original_schedule

	vim.api.nvim_exec_autocmds("VimLeavePre", {})
	assert(report_count() == before, "VimLeavePre did not clean a completed profile with pending presentation")
	assert(process.kill_count == 0, "VimLeavePre killed an already completed profile process")
	assert(process.wait_count == 0, "VimLeavePre waited on an already completed profile process")

	scheduled()
	assert(report_count() == before, "scheduled completion deleted or recreated an already cleaned report")
	assert(process.kill_count == 0 and process.wait_count == 0, "scheduled completion touched the completed process")
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		assert(vim.api.nvim_buf_get_name(buffer) ~= "startup://profile", "cancelled completion presented a report")
	end
end, debug.traceback)
vim.system = original_system
vim.schedule = original_schedule
vim.notify = original_notify
assert(race_ok, race_error)

startup_profile.run({ bang = false })
local presented = vim.wait(10000, function()
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(buffer) == "startup://profile" then
			return true
		end
	end
	return false
end, 50)
assert(presented, "completed StartupProfile did not present its report")
assert(report_count() == before, "completed StartupProfile leaked a report")

local bang_result = vim.system({ vim.v.progpath, "--headless", "+StartupProfile!", "+qa" }, { text = true }):wait()
assert(bang_result.code == 0, bang_result.stderr)
assert((bang_result.stdout .. bang_result.stderr):match("Startup total:"), "StartupProfile! did not print its summary")
assert(report_count() == before, "StartupProfile! leaked a report")

print("STARTUP_PROFILE_OK")
