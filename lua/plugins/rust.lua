vim.g.rustaceanvim = {
	tools = {},
	server = {
		on_attach = function(_, bufnr)
			LSP_MAPPINGS(bufnr)
		end,
		default_settings = {
			["rust-analyzer"] = {},
		},
	},
	dap = {},
}

return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
}
