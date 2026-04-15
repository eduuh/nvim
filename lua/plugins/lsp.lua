return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },
		config = function()
			-- Nvim 0.12 native LSP wiring: nvim-lspconfig ships per-server configs
			-- as lsp/*.lua runtime files, which vim.lsp.config() auto-discovers.
			local has_blink, blink = pcall(require, "blink.cmp")
			vim.lsp.config("*", {
				capabilities = has_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			-- Servers managed natively (rust_analyzer handled by rustaceanvim,
			-- ts_ls handled by typescript-tools.nvim)
			vim.lsp.enable({ "lua_ls", "cssls", "bashls", "marksman" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client:supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh({ bufnr = args.buf })
						vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
							buffer = args.buf,
							callback = function() vim.lsp.codelens.refresh({ bufnr = args.buf }) end,
						})
					end
					local map = vim.keymap.set
					local fzf = require("fzf-lua")
					local buf = { buffer = args.buf }

					-- LSP core
					map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", buf, { desc = "LSP Rename" }))
					map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", buf, { desc = "Show documentation" }))
					map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, vim.tbl_extend("force", buf, { desc = "Previous diagnostic" }))
					map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, vim.tbl_extend("force", buf, { desc = "Next diagnostic" }))
					map("n", "<leader>lr", "<cmd>LspRestart<CR>", vim.tbl_extend("force", buf, { desc = "Restart LSP" }))
					map("n", "<leader>gW", vim.lsp.buf.workspace_diagnostics, vim.tbl_extend("force", buf, { desc = "Workspace pull diagnostics" }))

					-- FZF-Lua LSP pickers
					map("n", "gr", fzf.lsp_references, vim.tbl_extend("force", buf, { desc = "LSP References" }))
					map("n", "gd", fzf.lsp_definitions, vim.tbl_extend("force", buf, { desc = "LSP Definitions" }))
					map("n", "gD", fzf.lsp_declarations, vim.tbl_extend("force", buf, { desc = "LSP Declarations" }))
					map("n", "gt", fzf.lsp_typedefs, vim.tbl_extend("force", buf, { desc = "LSP Type Definitions" }))
					map("n", "gi", fzf.lsp_implementations, vim.tbl_extend("force", buf, { desc = "LSP Implementations" }))
					map("n", "<leader>ws", fzf.lsp_workspace_symbols, vim.tbl_extend("force", buf, { desc = "Workspace Symbols" }))
					map("n", "gS", fzf.lsp_document_symbols, vim.tbl_extend("force", buf, { desc = "Document Symbols" }))

					-- Diagnostics via FZF-Lua
					map("n", "ge", fzf.lsp_workspace_diagnostics, vim.tbl_extend("force", buf, { desc = "Workspace Diagnostics" }))
					map("n", "gE", fzf.lsp_document_diagnostics, vim.tbl_extend("force", buf, { desc = "Document Diagnostics" }))
					map("n", "<leader>gd", fzf.lsp_document_diagnostics, vim.tbl_extend("force", buf, { desc = "Document Diagnostics" }))
					map("n", "<leader>gw", fzf.lsp_workspace_diagnostics, vim.tbl_extend("force", buf, { desc = "Workspace Diagnostics" }))

					-- Code actions
					map("n", "<leader>ca", fzf.lsp_code_actions, vim.tbl_extend("force", buf, { desc = "Code Action" }))
					map("v", "<leader>ca", fzf.lsp_code_actions, vim.tbl_extend("force", buf, { desc = "Code Action (Visual)" }))
				end,
			})
		end,
	},
}
