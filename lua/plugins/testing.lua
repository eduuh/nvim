local M = {}

function M.setup()
	require("neotest-gtest").setup({})
	require("neotest").setup({
		adapters = {
			require("neotest-gtest"),
			require("rustaceanvim.neotest"),
		},
	})
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"alfaix/neotest-gtest",
		"mrcjkb/rustaceanvim",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		M.setup()
	end,
}
