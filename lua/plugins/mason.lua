local ensure_installed = {
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"emmet_ls",
	"jsonls",
	"bashls",
	"ts_ls",
	"rust_analyzer",
	"dockerls",
	"clangd",
	"eslint",
	"bashls",
}

return {
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = ensure_installed,
				auto_update = false,
				run_on_start = true,
				start_delay = 0,
				debounce_hours = 5,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
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
					"prettier",
					"stylua",
					"eslint_d",
					"vim-language-server",
					"prettierd",
					"clang-format",
					"js-debug-adapter",
					"chrome-debug-adapter",
					"codelldb",
					"cpptools",
				},
			})
		end,
	},
}
