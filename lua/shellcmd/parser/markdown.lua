local M = {}

function M.get_current_cell()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local start, stop
	for i = row, 0, -1 do
		if lines[i]:match("^```[a-z]*sh") then
			start = i
			break
		end
	end
	if not start then
		return nil
	end

	for i = row + 1, #lines do
		if lines[i]:match("^```") then
			stop = i
			break
		end
	end
	if not stop then
		return nil
	end

	local cmd_lines = {}
	for i = start + 1, stop - 1 do
		table.insert(cmd_lines, lines[i])
	end
	local bufnr = vim.api.nvim_get_current_buf()

	return {
		buf = bufnr,
		range = { start = start, stop = stop },
		command = table.concat(cmd_lines, "\n"),
	}
end

return M
