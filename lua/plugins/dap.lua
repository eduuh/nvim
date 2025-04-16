return {
	{
		"mfussenegger/nvim-dap",
		-- Remove VeryLazy and only use keys for more targeted loading
		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- {
			-- 	"theHamsta/nvim-dap-virtual-text",
			-- 	opts = {},
			-- },
		},

		keys = {
			{
				";d",
				function()
					require("fzf-lua").dap_commands()
				end,
				desc = "dap commands",
			},
			{
				"<leader>db",
				function()
					require("fzf-lua").dap_breakpoints()
				end,
				desc = "dap commands",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				";b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle REPL",
			},
			{
				";r",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
			},
			{
				";l",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				";o",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>;i",
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
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
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
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				";k",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				";h",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		},

		config = function()
			local dap_icons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(dap_icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			local json = require("plenary.json")

			local vscode = require("dap.ext.vscode")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end

			require("overseer").enable_dap() -- task runner
			require("config.dap.codelldb").register_codelldb_dap()
			require("config.dap.jsandts").register_jsandts_dap()
			require("config.dap.lua").register_lua_dap()
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
		end,
	},
	{
		"mfussenegger/nvim-dap",
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
			"microsoft/vscode-js-debug",
		},
		config = function()
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
			if vim.fn.filereadable(".vscode/launch.json") then
				vscode.load_launchjs()
			else
				require("config.dap.jsandts").setup_if_no_vscode_config()
				require("config.dap.codelldb").register_codelldb_dap()
			end
		end,
	},
}
