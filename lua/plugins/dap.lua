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
				";L",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
				end,
				desc = "Logpoint",
			},
			{
				";e",
				function()
					local dap = require("dap")
					local session = dap.session()
					local filters = session and session.capabilities and session.capabilities.exceptionBreakpointFilters
					if not filters or vim.tbl_isempty(filters) then
						vim.notify("Active debug adapter does not advertise exception breakpoint filters", vim.log.levels.INFO)
						return
					end

					local choices = {}
					local defaults = {}
					for _, filter in ipairs(filters) do
						if filter.default then
							table.insert(defaults, filter.filter)
						end
						table.insert(choices, {
							label = filter.label .. (filter.default and " (default)" or ""),
							description = filter.description,
							filters = { filter.filter },
						})
					end
					if #defaults > 1 then
						table.insert(choices, 1, {
							label = "Adapter defaults",
							description = "Enable all filters marked as default by the adapter",
							filters = defaults,
						})
					end
					table.insert(choices, { label = "Disable exception breaks", filters = {} })

					vim.ui.select(choices, {
						prompt = "Exception breakpoints",
						format_item = function(item)
							return item.description and (item.label .. " — " .. item.description) or item.label
						end,
					}, function(item)
						if item then
							dap.set_exception_breakpoints(item.filters)
						end
					end)
				end,
				desc = "Exception breakpoints",
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
				"<leader>dw",
				function()
					require("dapui").elements.watches.add()
				end,
				mode = { "n", "v" },
				desc = "Add DAP watch",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Evaluate expression",
			},
			{
				";t",
				function()
					local dap = require("dap")
					local session = dap.session()
					-- On an `attach` session the debuggee is someone else's process --
					-- a dev server you attached to. `terminate` kills it; detaching
					-- leaves it running so you can attach again.
					if session and (session.config or {}).request == "attach" then
						dap.disconnect({ terminateDebuggee = false })
					else
						dap.terminate()
					end
				end,
				desc = "dap terminate (detach when attached)",
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
