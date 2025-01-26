local M = {}

M.register_codelldb_dap = function()
	local dap = require("dap")

	dap.adapters.codelldb = {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb",
			args = { "--port", "${port}" },
		},
	}

	require("dap").configurations["cpp"] = {
		{
			name = "cpp (lua Config)",
			type = "codelldb",
			preLaunchTask = "Compile",
			postDebugTask = "Clean",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stop0nEntry = true,
		},
	}

	require("dap").configurations["c"] = {
		{
			name = "c (lua Config)",
			type = "codelldb",
			preLaunchTask = "CompileC",
			postDebugTask = "CleanC",
			request = "launch",
			program = "${workspaceFolder}/${fileBasenameNoExtension}",
			-- program = function()
			--  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- end,
			cwd = "${workspaceFolder}",
			stop0nEntry = true,
		},
	}

	require("dap").configurations["rust"] = {
		{
			name = "Rust (lua config)",
			type = "codelldb", --gdb_custom,
			--preLaunchTask = { "clang++ -std=c++2a ${file} --debug" },
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stop0nEntry = true,
		},
	}
end

return M
