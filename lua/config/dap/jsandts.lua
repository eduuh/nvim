---@diagnostic disable: undefined-global
local M = {}

local js_based_languages = {
	"javascript",
	"javascriptreact",
	"typescriptreact",
	"typescript",
}

M.register_jsandts_dap = function()
	local dap = require("dap")

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

	dap.adapters["pwa-node"] = {
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

	local vscode = require("dap.ext.vscode")
	vscode.type_to_filetypes["node"] = js_based_languages
	vscode.type_to_filetypes["pwa-node"] = js_based_languages
end

M.setup_if_no_vscode_config = function()
	for _, language in ipairs(js_based_languages) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node (lua config)",
				request = "launch",
				name = "launch typescript file",
				cwd = vim.fn.getcwd(),
				runtimeArgs = { "-r", "ts-node/register" },
				runtimeExecutable = "node",
				args = { "${relativeFile}" },
				rootPath = "${workspaceFolder}",
				console = "integratedTerminal",
				skipFiles = { "<node_internals>/**", "node_modules/**" },
			},
			{
				type = "pwa-node (lua config)",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node (lua config)",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-chrome (lua config)",
				request = "attach",
				name = "Attach Program (pwa-chrome = { port: 9222 })",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
			{
				type = "pwa-node (lua config)",
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
end

return M
