return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = "rust",
		dependencies = {
			"mason-org/mason-registry",
			{
				"saecki/crates.nvim",
				event = "VeryLazy",
				ft = { "toml" },
				config = function()
					require("crates").setup()
				end,
			},
		},
		config = function()
			local mason_packages = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
			local codelldb_path = vim.fs.joinpath(mason_packages, "codelldb")
			local liblldb_path = vim.fs.joinpath(mason_packages, "lldb", "lib", "liblldb.so")
			local cfg = require("rustaceanvim.config")

			vim.g.rustaceanvim = {
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
				inlay_hints = {
					highlight = "NonText",
				},
				tools = {
					hover_actions = {
						auto_focus = true,
					},
				},
				server = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			}
		end,
	},
}
