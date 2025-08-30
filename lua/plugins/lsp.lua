return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
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
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function()
					local map = vim.keymap.set
					local fzf = require("fzf-lua")

					-- LSP core
					map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
					map("n", "K", vim.lsp.buf.hover, { desc = "Show documentation" })
					map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
					map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
					map("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

					-- FZF-Lua LSP pickers
					map("n", "gr", fzf.lsp_references, { desc = "LSP References" })
					map("n", "gd", fzf.lsp_definitions, { desc = "LSP Definitions" })
					map("n", "gD", fzf.lsp_declarations, { desc = "LSP Declarations" })
					map("n", "gt", fzf.lsp_typedefs, { desc = "LSP Type Definitions" })
					map("n", "gi", fzf.lsp_implementations, { desc = "LSP Implementations" })
					map("n", "gs", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })
					map("n", "gS", fzf.lsp_document_symbols, { desc = "Document Symbols" })

					-- Diagnostics via FZF-Lua
					map("n", "ge", fzf.lsp_workspace_diagnostics, { desc = "Workspace Diagnostics" })
					map("n", "gE", fzf.lsp_document_diagnostics, { desc = "Document Diagnostics" })
					map("n", "<leader>gd", fzf.lsp_document_diagnostics, { desc = "Document Diagnostics" })
					map("n", "<leader>gw", fzf.lsp_workspace_diagnostics, { desc = "Workspace Diagnostics" })

					-- Code actions
					map("n", "<leader>ca", fzf.lsp_code_actions, { desc = "Code Action" })
					map("v", "<leader>ca", fzf.lsp_code_actions, { desc = "Code Action (Visual)" })
				end,
			})
		end,
	},
}
