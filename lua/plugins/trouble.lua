return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: workspace diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: document diagnostics" },
		{ "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Trouble: symbols" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: quickfix" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: loclist" },
	},
}
