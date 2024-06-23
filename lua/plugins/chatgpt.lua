return {
	{
		"jackMort/ChatGPT.nvim",
		enabled = require("utils").isEnabled,
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://personal/openai/credential --no-newline",
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{ "github/copilot.vim", enabled = false },
}
