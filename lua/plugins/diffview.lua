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
		{ "<leader>vd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
		{ "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
		{ "<leader>vb", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: branch history" },
		{ "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
	},
}
