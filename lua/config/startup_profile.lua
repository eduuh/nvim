local M = {}
local active = {}

local function report_path()
	return vim.fs.joinpath(vim.fn.stdpath("state"), ("startup-profile-%s.log"):format(vim.uv.hrtime()))
end

function M.summarize(lines)
	local entries = {}
	local total = 0

	for _, line in ipairs(lines) do
		local timings, label = line:match("^%s*([%d%.%s]+):%s*(.+)$")
		if timings and label then
			local values = {}
			for value in timings:gmatch("%d+%.%d+") do
				table.insert(values, tonumber(value))
			end
			total = math.max(total, values[1] or 0)
			local self_time = values[#values] or 0
			if self_time >= 1 and not label:match("^%-%-%-") then
				table.insert(entries, { duration = self_time, label = label })
			end
		end
	end

	table.sort(entries, function(left, right)
		return left.duration > right.duration
	end)

	local summary = { ("Startup total: %.2f ms"):format(total), "Slowest startup entries (self time):" }
	for index = 1, math.min(10, #entries) do
		local entry = entries[index]
		table.insert(summary, ("%6.2f ms  %s"):format(entry.duration, entry.label))
	end
	if #entries == 0 then
		table.insert(summary, "No entries took at least 1 ms.")
	end
	return summary
end

local function present(lines, headless)
	local summary = M.summarize(lines)
	if headless then
		vim.api.nvim_echo({ { table.concat(summary, "\n") } }, true, {})
		return
	end

	vim.cmd("new")
	local buffer = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(buffer, "startup://profile")
	vim.bo[buffer].buftype = "nofile"
	vim.bo[buffer].bufhidden = "wipe"
	vim.bo[buffer].swapfile = false
	vim.bo[buffer].filetype = "startuptime"
	local output = vim.list_extend(vim.deepcopy(summary), { "", "Full report:" })
	vim.list_extend(output, lines)
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, output)
	vim.bo[buffer].modifiable = false
end

local function delete_report(profile)
	if profile.report_deleted then
		return
	end
	profile.report_deleted = true
	vim.fn.delete(profile.path)
end

local function finish(profile, result, headless)
	local lines = vim.fn.filereadable(profile.path) == 1 and vim.fn.readfile(profile.path) or {}
	delete_report(profile)
	if result.code ~= 0 then
		local detail = vim.trim(result.stderr or "")
		error(
			("Startup profiling failed with exit code %d%s"):format(
				result.code,
				detail ~= "" and (": " .. detail) or ""
			)
		)
	end
	present(lines, headless)
end

function M.run(options)
	local path = report_path()
	local command = { vim.v.progpath, "--headless", "--startuptime", path, "+qa" }
	if options.bang then
		finish({ path = path }, vim.system(command, { text = true }):wait(), true)
		return
	end

	vim.notify("Profiling a separate Neovim startup…", vim.log.levels.INFO)
	local profile = { path = path }
	active[profile] = true
	profile.process = vim.system(command, { text = true }, function(result)
		if profile.cancelled then
			return
		end
		profile.completed = true
		vim.schedule(function()
			if profile.cancelled or profile.finished then
				return
			end
			profile.finalizing = true
			local ok, message = pcall(finish, profile, result, false)
			profile.finalizing = false
			profile.finished = true
			if not ok then
				vim.notify(message, vim.log.levels.ERROR)
			end
			active[profile] = nil
		end)
	end)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("startup-profile-cleanup", { clear = true })
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			for profile in pairs(active) do
				profile.cancelled = true
				active[profile] = nil
				if profile.process and not profile.completed then
					pcall(profile.process.kill, profile.process, 15)
					pcall(profile.process.wait, profile.process)
				end
				delete_report(profile)
			end
		end,
		desc = "Clean up unfinished startup profiles",
	})
	vim.api.nvim_create_user_command("StartupProfile", function(options)
		M.run(options)
	end, {
		bang = true,
		desc = "Profile a separate Neovim startup (! prints a headless summary)",
	})
end

return M
