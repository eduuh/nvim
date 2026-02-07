return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "codecompanion" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		heading = { enabled = true },
		code = { enabled = true, style = "full" },
		bullet = { enabled = true },
		checkbox = { enabled = true },
		pipe_table = { enabled = true },
	},
}
