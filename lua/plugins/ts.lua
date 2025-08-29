return {
	"pmizio/typescript-tools.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"windwp/nvim-ts-autotag",
			event = "VeryLazy",
			opts = {},
		},
		{
			"folke/ts-comments.nvim",
			event = "VeryLazy",
			opts = {},
		},
	},
	config = function()
		require("typescript-tools").setup({})
	end,
}
