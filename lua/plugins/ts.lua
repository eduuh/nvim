return {
	"pmizio/typescript-tools.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"windwp/nvim-ts-autotag",
			event = "VeryLazy",
		},
		{
			"folke/ts-comments.nvim",
			event = "VeryLazy",
		},
	},
	config = function()
		require("typescript-tools").setup({})
	end,
}
