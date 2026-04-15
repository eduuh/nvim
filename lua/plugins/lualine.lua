return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			globalstatus = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff" },
			lualine_c = {
				{ "filename", path = 1 },
				{ function() return vim.ui.progress_status() or "" end },
			},
			lualine_x = {
				{ function() return vim.diagnostic.status() or "" end },
				"diagnostics",
			},
			lualine_y = { "filetype" },
			lualine_z = { "location" },
		},
	},
}
