return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	opts = {
		enhanced_diff_hl = true,
		view = {
			default = { layout = "diff2_horizontal" },
			file_history = { layout = "diff2_horizontal" },
		},
	},
	keys = {
		{ "<leader>vd", function() vim.cmd.DiffviewOpen() end, desc = "Diffview: open" },
		{ "<leader>vh", function() vim.cmd.DiffviewFileHistory("%") end, desc = "Diffview: file history" },
		{ "<leader>vb", function() vim.cmd.DiffviewFileHistory() end, desc = "Diffview: branch history" },
		{ "<leader>vc", function() vim.cmd.DiffviewClose() end, desc = "Diffview: close" },
	},
}
