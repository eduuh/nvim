---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

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

	for _, language in ipairs(js_based_languages) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node",
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
			name = "Launch Cpp",
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

local dap_icons = {
	Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = { " ", "DiagnosticError" },
	LogPoint = ".>",
}

return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		},

		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(dap_icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		event = "VeryLazy",
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		opts = {},
		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"microsoft/vscode-js-debug",
		},
		config = function()
			M.vscode_config()
			M.dap_configurations()
		end,
	},
}
