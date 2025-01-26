return {

	{
		"vhyrro/luarocks.nvim",
		-- this plugin needs to run before anything else
		priority = 1001,
		opts = {
			rocks = { "tree-sitter-http" },
		},
	},
	{
		"mistweaverco/kulala.nvim",
		opts = {},
		keys = {
			{ "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
			{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Run request" },
			{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Run request" },
			{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Run request" },
			{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Run request" },
			{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Run request" },
			{ "<leader>ri", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Run request" },
		},
	},
	{
		"rest-nvim/rest.nvim",
		enabled = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, "http")
			end,
		},
		ft = "http",
		keys = {
			{
				"<leader>rr",
				"<cmd>Rest run<cr>",
				desc = "Run File",
			},
			{
				"<leader>re",
				function()
					require("telescope").extensions.rest.select_env()
				end,
				desc = "Rest Environment",
			},
		},
	},
}
