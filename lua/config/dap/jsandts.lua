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
		-- js-debug is a large bundle: ~5s to bind its port on an idle machine,
		-- but measured at 85s with a dev server and a TS server running.
		-- nvim-dap only retries 14 x 250ms = 3.5s before giving up, so every
		-- launch died with ECONNREFUSED. 600 retries is a 150s budget, which
		-- only costs time when the adapter genuinely fails to start.
		options = { max_retries = 600 },
	}
end

M.register_jsandts_dap = function()
	local dap = require("dap")
	-- "all" halts on every *caught* throw too. Real toolchains throw constantly
	-- as control flow -- yarn's CLI and jest-resolve's module probing both do --
	-- so "all" stops dozens of times in third-party code before ever reaching
	-- your breakpoint. "uncaught" still catches the crashes you care about.
	dap.defaults["pwa-node"].exception_breakpoints = { "uncaught" }
	dap.defaults["pwa-chrome"].exception_breakpoints = { "uncaught" }

	-- Hand out a fresh table per session: nvim-dap substitutes ${port} by
	-- mutating the adapter in place, so a shared table would pin every later
	-- session to the first session's (now dead) port.
	for _, name in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
		dap.adapters[name] = function(cb)
			cb(adapter())
		end
	end

	local function alias(from, to)
		dap.adapters[from] = function(cb, config)
			config.type = to
			cb(adapter())
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

M.current_file_config = function(path)
	local context = js_package.debug_context(path or vim.api.nvim_buf_get_name(0))
	return {
		type = "pwa-node",
		request = "launch",
		name = "Debug current file",
		program = context.program,
		args = context.args,
		cwd = context.root,
		runtimeExecutable = context.runtime,
		runtimeArgs = context.runtime_args,
		sourceMaps = true,
		smartStep = true,
		resolveSourceMapLocations = {
			vim.fs.joinpath(context.root, "**"),
			("!%s"):format(vim.fs.joinpath(context.root, "node_modules", "**")),
		},
		skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
	}
end

M.current_file_config_entry = function()
	return setmetatable({ name = "Debug current file" }, {
		__call = function()
			return M.current_file_config()
		end,
	})
end

-- Saving must never block running or debugging. A failing BufWritePre
-- autocommand -- a formatter that is not installed, say -- makes `:write` throw,
-- and an unguarded write aborts the whole launch before the runner ever starts.
-- Observed 2026-09-05: mason failing to install clang-format killed
-- `debug_nearest` with "BufWritePre Autocommands for \"*\": Vim(append)".
local function save_quietly()
  local ok, err = pcall(vim.cmd.write)
  if not ok then
    vim.notify("Continuing without saving: " .. tostring(err), vim.log.levels.WARN)
  end
end

M.debug_current_file = function()
	local ok, config = pcall(M.current_file_config)
	if not ok then
		vim.notify(config, vim.log.levels.ERROR)
		return
	end
	save_quietly()
	require("lazy").load({ plugins = { "nvim-dap" } })
	require("dap").run(config)
end

M.package_script_config = function(root, script)
	js_package.debug_runtime(root)
	local command = js_package.script(root, script)
	return {
		type = "pwa-node",
		request = "launch",
		name = "Debug package script: " .. script,
		runtimeExecutable = command[1],
		runtimeArgs = vim.list_slice(command, 2),
		cwd = root,
		console = "integratedTerminal",
		internalConsoleOptions = "neverOpen",
		sourceMaps = true,
		skipFiles = { "<node_internals>/**", vim.fs.joinpath(root, "node_modules", "**") },
	}
end

local function browser_root()
	local ok, root = pcall(js_package.root, vim.api.nvim_buf_get_name(0))
	return ok and root or vim.fn.getcwd()
end

M.dev_server_url = function()
	return vim.fn.input("Rsbuild dev server URL: ", "http://localhost:3000")
end

M.browser_launch_config = function(url)
	return {
		type = "pwa-chrome",
		request = "launch",
		name = "Launch browser for dev server",
		runtimeExecutable = find_browser,
		url = url or M.dev_server_url,
		webRoot = browser_root,
		sourceMaps = true,
	}
end

M.browser_attach_config = function(port)
	return {
		type = "pwa-chrome",
		request = "attach",
		name = ("Attach to browser on port %d"):format(port),
		sourceMaps = true,
		port = port,
		webRoot = browser_root(),
	}
end

M.attach_browser = function()
	vim.ui.input({ prompt = "Browser remote-debugging port: ", default = "9222" }, function(value)
		if value == nil then
			return
		end
		local port = tonumber(value)
		if not port or port < 1 or port > 65535 or port % 1 ~= 0 then
			vim.notify("Browser debugging port must be an integer from 1 to 65535", vim.log.levels.ERROR)
			return
		end
		require("lazy").load({ plugins = { "nvim-dap" } })
		require("dap").run(M.browser_attach_config(port))
	end)
end

M.setup_if_no_vscode_config = function()
	for _, language in ipairs(js_based_languages) do
		require("dap").configurations[language] = {
			M.current_file_config_entry(),
			M.browser_launch_config(),
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
				-- Extensionless: jest 29+ ships an "exports" map that only publishes
				-- "./bin/jest", so resolving "jest/bin/jest.js" fails outright. Node
				-- adds the .js itself for packages without an exports map.
				program = test_program("jest/bin/jest"),
				-- --coverage=false: istanbul instrumentation breaks breakpoint line
				-- mapping (see lua/config/js_tests.lua).
				args = { "--runInBand", "--coverage=false" },
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
