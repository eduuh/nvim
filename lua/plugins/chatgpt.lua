return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = false,
					auto_trigger = false,
					debounce = 75,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = true,
					markdown = true,
					help = false,
					gitcommit = true,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node",
				server_opts_overrides = {},
			})

			require("copilot_cmp").setup()
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT" },
		enabled = require("config.utils").isMac,
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://personal/openai/credential --no-newline ",
				openai_params = {
					model = "chatgpt-4o-latest",
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
}
