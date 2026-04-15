return {
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
	},
}
