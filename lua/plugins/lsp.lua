return {
	{
		"lvimuser/lsp-inlayhints.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp-inlayhints").setup({
				inlay_hints = {
					parameter_hints = {
						show = true,
						prefix = "<- ",
						separator = ", ",
						remove_colon_start = false,
						remove_colon_end = true,
					},
					type_hints = {
						show = true,
						prefix = "",
						separator = ", ",
						remove_colon_start = false,
						remove_colon_end = true,
					},
					only_current_line = false,
					labels_separator = "  ",
					max_len_align = false,
					max_len_align_padding = 1,
					highlight = "LspInlayHint",
					priority = 0,
				},
				enabled_at_startup = true,
				debug_mode = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			local keymap = vim.keymap -- for conciseness

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf, silent = true }

					local diagnostic_goto = function(next, severity)
						local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
						severity = severity and vim.diagnostic.severity[severity] or nil
						return function()
							go({ severity = severity })
						end
					end

					-- Define a local helper for setting keymaps with descriptions
					local function map(mode, keys, action, desc)
						vim.keymap.set(mode, keys, action, { desc = desc, noremap = true, silent = true })
					end

					-- LSP keybindings
					map("n", "gr", vim.lsp.buf.references, "Show LSP references")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gd", vim.lsp.buf.definition, "Show LSP definitions")
					map("n", "gi", vim.lsp.buf.implementation, "Show LSP implementations")
					map("n", "gt", vim.lsp.buf.type_definition, "Show LSP type definitions")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
					map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")

					-- Diagnostics keybindings
					map("n", "<leader>D", vim.diagnostic.setloclist, "Show buffer diagnostics")
					map("n", "<leader>dl", vim.diagnostic.open_float, "Show line diagnostics")
					map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")

					-- Error & Warning navigation
					map("n", "]e", function()
						diagnostic_goto(true, "ERROR")
					end, "Next Error")
					map("n", "[e", function()
						diagnostic_goto(false, "ERROR")
					end, "Previous Error")
					map("n", "]w", function()
						diagnostic_goto(true, "WARN")
					end, "Next Warning")
					map("n", "[w", function()
						diagnostic_goto(false, "WARN")
					end, "Previous Warning")

					-- LSP actions
					map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
				end,
			})

			-- Change the Diagnostic symbols in the sign column (gutter)
			-- (not in youtube nvim video)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},
}
