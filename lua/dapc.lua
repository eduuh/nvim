local M = {}
-- custom adapter for running tasks before starting debug
local custom_adapter = "pwa-node-custom"
local dap = require("dap")
dap.adapters[custom_adapter] = function(cb, config)
	if config.preLaunchTask then
		local async = require("plenary.async")
		local notify = require("notify").async

		async.run(function()
			---@diagnostic disable-next-line: missing-parameter
			notify("Running [" .. config.preLaunchTask .. "]").events.close()
		end, function()
			vim.fn.system(config.preLaunchTask)
			config.type = "pwa-node"
			dap.run(config)
		end)
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
			"node",
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

	local js_based_languages = { "typescript", "javascript", "typescriptreact" }

	for _, language in ipairs(js_based_languages) do
		require("dap").configurations[language] = {
			{
				name = "Debug Typescript File",
				type = "pwa-node",
				request = "launch",
				program = "${file}",
				args = {
					"${relativeFile}",
				},
				runtimeArgs = {
					"-r",
					"ts-node/register",
				},
				cwd = "${workspaceFolder}",
				protocol = "inspector",
				internalConsoleOptions = "openOnSessionStart",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Node: Launch JS File",
				cwd = "${workspaceFolder}", -- vim.fn.getcwd(),
				args = { "${file}" },
				sourceMaps = true,
				protocol = "inspector",
			},
			-- {
			-- 	type = "pwa-node",
			-- 	request = "launch",
			-- 	name = "Launch Current File (Typescript)",
			-- 	cwd = "${workspaceFolder}",
			-- 	runtimeArgs = { "--loader=ts-node/esm" },
			-- 	program = "${file}",
			-- 	runtimeExecutable = "ts-node",
			-- 	-- args = { '${file}' },
			-- 	sourceMaps = true,
			-- 	protocol = "inspector",
			-- 	outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
			-- 	skipFiles = { "<node_internals>/**", "node_modules/**" },
			-- 	resolveSourceMapLocations = {
			-- 		"${workspaceFolder}/**",
			-- 		"!**/node_modules/**",
			-- 	},
			-- },
			{
				name = "JNode: Attach to node process",
				type = "pwa-node",
				request = "attach",
				rootPath = "${workspaceFolder}",
				processId = require("dap.utils").pick_process,
			},
		}
	end
end
return M
