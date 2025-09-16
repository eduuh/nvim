local M = {}
local ns = vim.api.nvim_create_namespace("shellcmd_output")

local function split_lines(str)
	if not str or str == "" then
		return {}
	end
	return vim.split(str, "\n", { trimempty = true })
end

-- Hover-style floating window with output
local function open_float(cell, result)
	local bufnr = vim.api.nvim_create_buf(false, true) -- scratch
	local lines = {}

	table.insert(lines, "# status: " .. (result.code == 0 and "ok" or "fail"))
	if result.stdout ~= "" then
		vim.list_extend(lines, split_lines(result.stdout))
	end
	if result.stderr ~= "" then
		vim.list_extend(lines, split_lines(result.stderr))
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].filetype = "sh"

	-- position below cell
	local row = cell.range.stop + 1
	local col = 0
	local width = math.floor(vim.o.columns * 0.7)
	local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.3))

	local win = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})

	-- close on <q> in normal mode
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = bufnr, nowait = true, silent = true })
end

function M.show(cell, result)
	local bufnr = vim.api.nvim_get_current_buf()

	-- inline ✔/✖ at end of fence
	vim.api.nvim_buf_clear_namespace(bufnr, ns, cell.range.stop, cell.range.stop + 1)
	local status = result.code == 0 and { { " ✔", "DiffAdded" } } or { { " ✖", "DiffRemoved" } }
	vim.api.nvim_buf_set_extmark(bufnr, ns, cell.range.stop, 0, { virt_text = status, virt_text_pos = "eol" })

	-- hover-doc style window
	open_float(cell, result)
end

return M
