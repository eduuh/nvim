return {
	{
		"github/copilot.vim",
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT" },
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://personal/openai/credential --no-newline ",
				openai_params = {
					model = "gpt-4o",
					frequency_penalty = 0,
					presence_penalty = 0,
					max_tokens = 3000,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
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
