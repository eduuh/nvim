return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		config = function()
			require("gruvbox").setup({})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		opts = {
			options = {
				theme = "gruvbox",
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
	{
		"echasnovski/mini.surround",
		branch = "stable",
		main = "mini.surround",
		opts = {
			search_method = "cover_or_next",
		},
	},
}
