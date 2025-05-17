return {
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				view_options = {},
			})
		end,
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
			{
				";f",
				function()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local cwd = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":h") or vim.fn.getcwd()
					require("oil").new_file(cwd)
				end,
				desc = "Create new file in current directory",
			},
		},
	},
}
