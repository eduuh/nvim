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
				"<leader>d",
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
			local dap = require("dap")
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
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
			"microsoft/vscode-js-debug",
		},
		event = "VeryLazy",
		config = function()
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
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (pwa-node)",
						cwd = "${workspaceFolder}", -- vim.fn.getcwd(),
						args = { "${file}" },
						sourceMaps = true,
						protocol = "inspector",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (Typescript)",
						cwd = "${workspaceFolder}",
						runtimeArgs = { "--loader=ts-node/esm" },
						program = "${file}",
						runtimeExecutable = "ts-node",
						-- args = { '${file}' },
						sourceMaps = true,
						protocol = "inspector",
						outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
						skipFiles = { "<node_internals>/**", "node_modules/**" },
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					{
						name = "Launch",
						type = "pwa-node",
						request = "launch",
						program = "${file}",
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = { "<node_internals>/**" },
						protocol = "inspector",
						console = "integratedTerminal",
					},
					{
						name = "Attach to node process",
						type = "pwa-node",
						request = "attach",
						rootPath = "${workspaceFolder}",
						processId = require("dap.utils").pick_process,
					},
					{
						name = "Debug Main Process (Electron)",
						type = "pwa-node",
						request = "launch",
						program = "${file}",
						args = {
							"${workspaceFolder}/dist/${file}.js",
						},
						outFiles = {
							"${workspaceFolder}/dist/*.js",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/dist/**/*.js",
							"${workspaceFolder}/dist/*.js",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = { "<node_internals>/**" },
						protocol = "inspector",
						console = "integratedTerminal",
					},
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
				}
			end
		end,
	},
}
