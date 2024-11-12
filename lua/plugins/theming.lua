return {
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "warmer",
			})
			require("onedark").load()
		end,
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
