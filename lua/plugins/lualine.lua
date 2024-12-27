return {
	"nvim-lualine/lualine.nvim",
	lazy = false, -- load immediately so there is no flickering
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						"rest",
						icon = "",
						fg = "#428890",
					},
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
