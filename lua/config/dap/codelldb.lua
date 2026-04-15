---@diagnostic disable: undefined-global
local M = {}

M.register_codelldb_dap = function()
	local dap = require("dap")

	dap.adapters.codelldb = {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = {
			command = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "codelldb", "codelldb"),
			args = { "--port", "${port}" },
		},
	}
end

return M
