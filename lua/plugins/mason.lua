return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Nvim 0.12: mason-lspconfig is gone. Install servers directly here;
			-- vim.lsp.enable() in lsp.lua handles the start/stop wiring.
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers (previously in mason-lspconfig.ensure_installed)
					"lua-language-server",
					"css-lsp",
					"bash-language-server",
					"marksman",
					-- (rust-analyzer installed via rustaceanvim + mason-registry)
					-- (typescript-language-server installed on demand by typescript-tools.nvim)

					-- Formatters & linters
					"prettier",
					"prettierd",
					"stylua",
					"eslint_d",
					"clang-format",
				},
			})
		end,
	},
}
