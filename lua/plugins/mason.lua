return {
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = {
					"html",
					"rust_analyzer",
					"cssls",
					"tailwindcss",
					"svelte",
					"lua_ls",
					"graphql",
					"emmet_ls",
					"prismals",
					"pyright",
					"lua_ls",
					"cmake",
					"dockerls",
					"jsonls",
					"clangd",
					"jdtls",
					"eslint",
					"ts_ls",
				},
				auto_update = false,
				run_on_start = true,
				start_delay = 0,
				debounce_hours = 5,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- import mason
			local mason = require("mason")

			-- import mason-lspconfig

			local mason_tool_installer = require("mason-tool-installer")

			-- enable mason and configure icons
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint",
					"eslint_d",
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
			})
		end,
	},
}
