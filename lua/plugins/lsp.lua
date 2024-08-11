return {
	{
		"VonHeikemen/lsp-zero.nvim",
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(_, bufnr)
				local map = vim.keymap.set

				local diagnostic_goto = function(next, severity)
					local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
					severity = severity and vim.diagnostic.severity[severity] or nil
					return function()
						go({ severity = severity })
					end
				end
				-- Mappings.
				local opts = { buffer = bufnr, noremap = true, silent = true }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
				map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
				map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
				map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
				map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
				map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
			end)

			require("lspconfig").tsserver.setup({
				single_file_support = true,
			})

			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)

			lsp_zero.format_on_save({
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				servers = {
					["tsserver"] = { "javascript", "typescript" },
					["rust_analyzer"] = { "rust" },
					["clangd"] = { "c", "c++" },
				},
			})

			lsp_zero.set_sign_icons({
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			})
		end,
	},
	{ "L3MON4D3/LuaSnip" },
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "tsserver", "lua_ls", "clangd" },
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					lua_ls = function()
						local lsp_zero = require("lsp-zero")
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					{ "bash-language-server", auto_update = true },
					"vim-language-server",
					"prettier",
					"prettierd",
					"clang-format",
					"js-debug-adapter",
					"stylua",
					"chrome-debug-adapter",
					"codelldb",
					"cpptools",
				},
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = true,
					["mason-nvim-dap"] = true,
				},
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
