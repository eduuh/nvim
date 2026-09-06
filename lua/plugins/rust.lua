return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = "rust",
		dependencies = {
			"mason-org/mason-registry",
			{
				"saecki/crates.nvim",
				ft = "toml",
				config = function()
					require("crates").setup()
				end,
			},
		},
		config = function()
			-- Both are paths to FILES, and both used to be wrong. `get_codelldb_adapter` execs the
			-- first and passes the second as `--liblldb`, but the first named the package
			-- *directory* (not an executable) and the second named an `lldb` mason package that
			-- does not exist — liblldb.so ships inside codelldb's own extension.
			local codelldb = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "codelldb")
			local codelldb_path = vim.fs.joinpath(codelldb, "extension", "adapter", "codelldb")
			local liblldb_path = vim.fs.joinpath(codelldb, "extension", "lldb", "lib", "liblldb.so")
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
						checkOnSave = true,
						check = {
							command = "clippy",
						},
					},
				},
			}
		end,
	},
}
