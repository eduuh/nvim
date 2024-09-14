---@diagnostic disable: duplicate-set-field
local M = {}
-- custom adapter for running tasks before starting debug
local dap = require("dap")

M.vscode_config = function()
	local vscode = require("dap.ext.vscode")
	local json = require("plenary.json")
	vscode.json_decode = function(str)
		return vim.json.decode(json.json_strip_comments(str))
	end
	if vim.fn.filereadable(".vscode/launch.json") then
		vscode.load_launchjs()
	end
end

M.dap_configurations = function()
	dap.adapters.nlua = function(callback, conf)
		local adapter = {
			type = "server",
			host = conf.host or "127.0.0.1",
			port = conf.port or 8086,
		}
		if conf.start_neovim then
			local dap_run = dap.run
			dap.run = function(c)
				adapter.port = c.port
				adapter.host = c.host
			end
			require("osv").run_this()
			dap.run = dap_run
		end
		callback(adapter)
	end

	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Run this file",
			start_neovim = {},
		},
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance (port = 8086)",
			port = 8086,
		},
	}
	require("dap-vscode-js").setup({
		node_path = "node",
		debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
		debugger_cmd = { "js-debug-adapter" },
		adapters = {
			"chrome",
			"pwa-node",
			"pwa-chrome",
			"node-terminal",
			"pwa-extensionHost",
		},
	})

	require("dap").adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
				"${port}",
			},
		},
	}

	dap.adapters["node"] = function(cb, config)
		if config.type == "node" then
			config.type = "pwa-node"
		end
		local nativeAdapter = dap.adapters["pwa-node"]
		if type(nativeAdapter) == "function" then
			nativeAdapter(cb, config)
		else
			cb(nativeAdapter)
		end
	end

	local js_based_languages = {
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"typescript",
	}

	local vscode = require("dap.ext.vscode")
	vscode.type_to_filetypes["node"] = js_based_languages
	vscode.type_to_filetypes["pwa-node"] = js_based_languages

	local js_languages = {
		"javascript",
		"javascriptreact",
	}

	for _, language in ipairs(js_languages) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-chrome",
				request = "attach",
				name = "Attach Program (pwa-chrome = { port: 9222 })",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Jest Tests",
				-- trace = true, -- include debugger info
				runtimeExecutable = "node",
				runtimeArgs = {
					"./node_modules/jest/bin/jest.js",
					"--runInBand",
				},
				rootPath = "${workspaceFolder}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
		}
	end

	local ts_based_languages = {
		"typescriptreact",
		"typescript",
	}

	for _, language in ipairs(ts_based_languages) do
		require("dap").configurations[language] = {
			{
				{
					type = "ts-node - Nvim",
					request = "node",
					name = "launch typescript file",
					cwd = vim.fn.getcwd(),
					runtimeArgs = { "-r", "ts-node/register" },
					runtimeExecutable = "node",
					args = { "${relativeFile}" },
					rootPath = "${workspaceFolder}",
					console = "integratedTerminal",
					skipFiles = { "<node_internals>/**", "node_modules/**" },
				},
			},
		}
	end

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
			name = "Launch",
			type = "codelldb",
			--preLaunchTask = { "clang++ -std=c++2a ${file} --debug" },
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stop0nEntry = true,
		},
	}

	require("dap").configurations["rust"] = {
		{
			name = "Launch",
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
