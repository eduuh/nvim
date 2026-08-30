---@diagnostic disable: undefined-global
local M = {}

local js_based_languages = {
	"javascript",
	"javascriptreact",
	"typescriptreact",
	"typescript",
}
local js_package = require("config.js_package")

local function test_root()
	return js_package.root(vim.api.nvim_buf_get_name(0))
end

local function test_runtime()
	return js_package.debug_runtime(test_root())
end

local function test_runtime_args()
	local _, args = test_runtime()
	return args or {}
end

local function test_program(request)
	return function()
		return js_package.resolve(test_root(), request)
	end
end

local function find_browser()
	for _, env_name in ipairs({ "CHROME_PATH", "CHROMIUM_PATH", "EDGE_PATH" }) do
		local path = vim.env[env_name]
		if path and path ~= "" and (vim.fn.executable(path) == 1 or vim.uv.fs_stat(path)) then
			return path
		end
	end

	for _, command in ipairs({
		"google-chrome-stable",
		"google-chrome",
		"chromium",
		"chromium-browser",
		"microsoft-edge-stable",
		"microsoft-edge",
	}) do
		if vim.fn.executable(command) == 1 then
			return vim.fn.exepath(command)
		end
	end

	for _, path in ipairs({
		"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
		"/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe",
		"/mnt/c/Program Files/Microsoft/Edge/Application/msedge.exe",
		"/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
	}) do
		if vim.uv.fs_stat(path) then
			return path
		end
	end

	error("No Chrome, Chromium, or Edge executable found. Install one or set CHROME_PATH, CHROMIUM_PATH, or EDGE_PATH.")
end

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
	dap.defaults["pwa-node"].exception_breakpoints = { "all" }
	dap.defaults["pwa-chrome"].exception_breakpoints = { "all" }

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

M.find_browser = find_browser

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
				type = "pwa-chrome",
				request = "launch",
				name = "Launch Chrome/Chromium/Edge",
				runtimeExecutable = find_browser,
				url = "http://localhost:3000",
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
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
				runtimeExecutable = test_runtime,
				runtimeArgs = test_runtime_args,
				program = test_program("jest/bin/jest.js"),
				args = { "--runInBand" },
				cwd = test_root,
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug current Vitest file",
				runtimeExecutable = test_runtime,
				runtimeArgs = test_runtime_args,
				program = test_program("vitest/vitest.mjs"),
				args = { "run", "${file}", "--no-file-parallelism" },
				cwd = test_root,
				console = "integratedTerminal",
				smartStep = true,
			},
		}
	end
end

return M
