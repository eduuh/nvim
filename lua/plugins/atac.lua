return {
	"NachoNievaG/atac.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	config = function()
		require("atac").setup({
			dir = "~/.config/nvim/config_test/apis", -- By default, the dir will be set as /tmp/atac
		})
	end,
	keys = {
		{
			"<leader>rr",
			"<cmd>Atac<cr>",
			desc = "Make request",
		},
	},
}
