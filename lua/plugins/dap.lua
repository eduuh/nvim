return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		keys = {
			{
				";b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				";d",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
			},
			{
				";o",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				";i",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},

			{
				"<leader>d",
				function()
					require("fzf-lua").dap_commands()
				end,
				desc = "dap commands",
			},
			{
				";t",
				function()
					require("dap").terminate()
				end,
				desc = "dap terminate",
			},
		},
		config = function()
			local json = require("plenary.json")

			local vscode = require("dap.ext.vscode")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end

			require("overseer").enable_dap()
			require("config.dap.codelldb").register_codelldb_dap()
			require("config.dap.jsandts").register_jsandts_dap()
			require("config.dap.lua").register_lua_dap()
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		config = function(_, _)
			local function set_dap_keymaps()
				local dap = require("dap")
				local opts = { buffer = true }
				vim.keymap.set("n", "<Down>", dap.step_over, vim.tbl_extend("force", opts, { desc = "DAP: Step Over" }))
				vim.keymap.set(
					"n",
					"<Right>",
					dap.step_into,
					vim.tbl_extend("force", opts, { desc = "DAP: Step Into" })
				)
				vim.keymap.set("n", "<Left>", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP: Step Out" }))
				vim.keymap.set(
					"n",
					"<Up>",
					dap.restart_frame,
					vim.tbl_extend("force", opts, { desc = "DAP: Restart Frame" })
				)
			end

			-- remove mappings when DAP session ends
			local function unset_dap_keymaps()
				vim.keymap.del("n", "<Down>")
				vim.keymap.del("n", "<Right>")
				vim.keymap.del("n", "<Left>")
				vim.keymap.del("n", "<Up>")
			end

			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup({})
			dap.listeners.after.event_initialized["dapui_config"] = function()
				set_dap_keymaps()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				unset_dap_keymaps()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				unset_dap_keymaps()
				dapui.close({})
			end

			dap.listeners.before.disconnect["dap_keymaps"] = function()
				unset_dap_keymaps()
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
