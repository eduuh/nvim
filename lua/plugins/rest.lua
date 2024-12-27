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
		"rest-nvim/rest.nvim",
		enabled = require("config.utils").isMac,
		ft = "http",
		config = function()
			require("telescope").load_extension("rest")
		end,
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
