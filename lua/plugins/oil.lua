return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		opts = {
			default_file_explorer = true,
			view_options = {},
		},
		keys = {
			{
				";;",
				function()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local cwd = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":h") or vim.fn.getcwd()
					require("oil").open(cwd)
				end,
				desc = "Open Oil in current directory",
			},
		},
	},
}
