local M = {}

function M.lcov_file()
	local js_package = require("config.js_package")
	local buffer_path = vim.api.nvim_buf_get_name(0)
	local cwd = vim.fn.getcwd()

	local ok, root = pcall(js_package.root, buffer_path ~= "" and buffer_path or cwd)
	if not ok and buffer_path ~= "" then
		ok, root = pcall(js_package.root, cwd)
	end
	if not ok then
		root = cwd
	end

	return vim.fs.joinpath(root, "coverage", "lcov.info")
end

return M
