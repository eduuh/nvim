return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jbyuki/one-small-step-for-vimkind",
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
				";B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional breakpoint",
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
				";u",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
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
			vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError", default = true })
			vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticInfo", default = true })
			vim.api.nvim_set_hl(0, "DapStopped", { link = "DiagnosticOk", default = true })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual", default = true })

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "✘", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
			})

			require("overseer").enable_dap()
			require("config.dap.codelldb").register_codelldb_dap()
			require("config.dap.jsandts").register_jsandts_dap()
			require("config.dap.lua").register_lua_dap()

			-- .vscode/launch.json is auto-loaded on-demand by nvim-dap's
			-- built-in dap.providers.configs["dap.launch.json"] provider, and
			-- Nvim 0.12's vim.json.decode natively handles the JSONC comments.
			-- Only register the hand-written JS/TS fallback configs when the
			-- project has no launch.json.
			if vim.fn.filereadable(".vscode/launch.json") ~= 1 then
				require("config.dap.jsandts").setup_if_no_vscode_config()
			end
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		config = function(_, _)
			local dap_keymap_bufnr

			local function set_dap_keymaps()
				local dap = require("dap")
				dap_keymap_bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = dap_keymap_bufnr }
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
				if not dap_keymap_bufnr or not vim.api.nvim_buf_is_valid(dap_keymap_bufnr) then
					return
				end
				for _, key in ipairs({ "<Down>", "<Right>", "<Left>", "<Up>" }) do
					vim.keymap.del("n", key, { buffer = dap_keymap_bufnr })
				end
				dap_keymap_bufnr = nil
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
}
