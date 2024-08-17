return {
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		opts = {
			options = {
				theme = "onedark",
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		-- i don't think lazy will be able to guess
		-- `ibl` is the main module, so set it manually
		main = "ibl",
		opts = {
			enabled = true,
			scope = {
				enabled = false,
			},
			indent = {
				char = "▏",
			},
		},
	},
}
