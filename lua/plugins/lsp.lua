return {
	{
		"VonHeikemen/lsp-zero.nvim",
		config = function()
			local lsp_zero = require("lsp-zero")

			require("lspconfig").tsserver.setup({
				single_file_support = true,
			})

			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)

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
		"w lliamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "tsserver", "lua_ls", "clangd" },
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					rust_analyzer = function() end,
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
					"rust-analyzer",
				},
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = true,
					["mason-nvim-dap"] = true,
				},
			})
		end,
	},
}
