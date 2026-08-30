---@diagnostic disable: undefined-global
local M = {}

local js_based_languages = {
	"javascript",
	"javascriptreact",
	"typescriptreact",
	"typescript",
}

local function adapter()
	local script = vim.fs.joinpath(
		vim.fn.stdpath("data"),
		"mason",
		"packages",
		"js-debug-adapter",
		"js-debug",
		"src",
		"dapDebugServer.js"
	)

	return {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = {
			command = "node",
			args = { script, "${port}" },
		},
	}
end

M.register_jsandts_dap = function()
	local dap = require("dap")

	for _, name in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
		dap.adapters[name] = adapter()
	end

	local function alias(from, to)
		dap.adapters[from] = function(cb, config)
			config.type = to
			cb(dap.adapters[to])
		end
	end
	alias("node", "pwa-node")
	alias("chrome", "pwa-chrome")
	alias("msedge", "pwa-msedge")

	local vscode = require("dap.ext.vscode")
	for _, name in ipairs({
		"node",
		"pwa-node",
		"chrome",
		"pwa-chrome",
		"msedge",
		"pwa-msedge",
		"node-terminal",
		"pwa-extensionHost",
	}) do
		vscode.type_to_filetypes[name] = js_based_languages
	end
end

M.setup_if_no_vscode_config = function()
	for _, language in ipairs(js_based_languages) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch current file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to Node process",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
			{
				type = "pwa-chrome",
				request = "attach",
				name = "Attach to Chrome on port 9222",
				sourceMaps = true,
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Jest Tests",
				runtimeExecutable = "node",
				runtimeArgs = {
					"${workspaceFolder}/node_modules/jest/bin/jest.js",
					"--runInBand",
				},
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug current Vitest file",
				program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
				args = { "run", "${file}", "--no-file-parallelism" },
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				smartStep = true,
			},
		}
	end
end

return M
