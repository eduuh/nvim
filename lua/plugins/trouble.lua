return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{
			"<leader>cS",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP references/definitions/... (Trouble)",
		},
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
		{ "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		{
			"<leader>tn",
			"<cmd>cnext<cr>",
			desc = "Previous Trouble/Quickfix Item",
		},
		{
			"<leader>tp",
			"<cmd>cprev<cr>",
			desc = "Next Trouble/Quickfix Item",
		},
	},
}
