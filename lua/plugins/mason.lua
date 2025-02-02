local ensure_installed = {
	"cssls",
	"lua_ls",
	"emmet_ls",
	"jsonls",
	"bashls",
	"rust_analyzer",
	"dockerls",
	"clangd",
	"eslint",
	"bashls",
	"marksman",
	"sqlls",
	"tsserver",
	"omnisharp",
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
				handlers = {
					function(server)
						local lspconfig = require("lspconfig")
						local capabilities = require("blink.cmp").get_lsp_capabilities()
						lspconfig[server].setup({
							capabilities = capabilities,
						})
					end,
				},
			})
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			automatic_installation = true,

			handlers = {},

			ensure_installed = {},
		},
		config = function() end,
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
					"netcoredbg",
					"js",
					"cppdbg",
					"node2",
					"chrome",
					"bash",
					"netcoredbg",
				},
			})
		end,
	},
}
