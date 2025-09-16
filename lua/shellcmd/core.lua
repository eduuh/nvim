local parser = require("shellcmd.parser.markdown")
local exec = require("shellcmd.exec.inline")
local output = require("shellcmd.ui.output")
local state = require("shellcmd.state")

local M = {}

function M.run_cell()
	local cell = parser.get_current_cell()
	if not cell then
		vim.notify("[shellcmd] No shell cell found", vim.log.levels.WARN)
		return
	end
	exec.run(cell, function(result)
		output.show(cell, result)
	end)
end

function M.open_output()
	local cell = parser.get_current_cell()
	if not cell then
		vim.notify("[shellcmd] No shell cell found", vim.log.levels.WARN)
		return
	end
	local result = state.get(cell)
	if not result then
		vim.notify("[shellcmd] No output for this cell", vim.log.levels.WARN)
		return
	end

	-- scratch buffer
	vim.cmd("vnew")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "sh"

	local lines = {}
	table.insert(lines, "# status: " .. (result.code == 0 and "ok" or "fail"))
	if result.stdout ~= "" then
		vim.list_extend(lines, vim.split(result.stdout, "\n"))
	end
	if result.stderr ~= "" then
		vim.list_extend(lines, vim.split(result.stderr, "\n"))
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M
