return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opt = {},
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>f", group = "Telescope" },
			{ "<leader>g", group = "Git" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>t", group = "Test" },
		})
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
