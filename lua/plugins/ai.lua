return {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
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
		end,
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		cmd = "MCPHub", -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				port = 37373,
				config = vim.fn.expand("~/.config/mcphub/servers.json"),
			})
		end,
	},
	{
		"yetone/avante.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"zbirenbaum/copilot.lua",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
		build = "make",
		opts = { provider = "copilot" },
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = false,
		enabled = true,
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			agent = "copilot",
			debug = false, -- Enable debugging
			model = "claude-3.5-sonnet",
			question_header = "## User ", -- Header to use for user questions
			answer_header = "## Copilot ", -- Header to use for AI answers
			error_header = "## Error ", -- Header to use for errors
		},
		keys = {
			{ "<leader>c", ":CopilotChatToggle<CR>", desc = "Copilot toggle" },
			{ "<leader>cc", ":CopilotChatCommitStaged<CR>", desc = "Copilot create staged" },
			{ "<leader>co", ":CopilotChatOptimize<CR>", desc = "Copilot create staged" },
			{ "<leader>cr", ":CopilotChatReview<CR>", desc = "Copilot create staged" },
			{ "<leader>ce", ":CopilotChatExplain<CR>", desc = "Copilot create staged" },
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
					end
				end,
				desc = "CopilotChat - Quick chat selected",
				mode = { "v" },
			},
		},
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT" },
		enabled = false,
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
