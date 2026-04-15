return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		opts = {
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
				layout = { position = "bottom", ratio = 0.4 },
			},
			suggestion = {
				enabled = false,
				auto_trigger = false,
				debounce = 75,
				keymap = {
					accept = "<C-l>",
					accept_word = false,
					accept_line = false,
					next = "<C-]>",
					prev = "<C-[>",
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
			server_opts_overrides = {},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		dependencies = {
			"j-hui/fidget.nvim",
			"ravitemer/codecompanion-history.nvim",
			"Davidyz/VectorCode",
			{
				"ravitemer/mcphub.nvim",
				cmd = "MCPHub",
				build = "npm install -g mcp-hub@latest",
				opts = {
					port = 37373,
					config = vim.fn.stdpath("config") .. "/mcphub/servers.json",
				},
			},
		},
		keys = {
			{
				"<C-a>",
				function() vim.cmd.CodeCompanionActions() end,
				desc = "CodeCompanion: action palette",
				mode = { "n", "v" },
			},
			{
				"<Leader>a",
				function() vim.cmd("CodeCompanionChat Toggle") end,
				desc = "CodeCompanion: toggle chat",
				mode = { "n", "v" },
			},
			{
				"<LocalLeader>a",
				function() vim.cmd("CodeCompanionChat Add") end,
				desc = "CodeCompanion: add selection to chat",
				mode = { "v" },
			},
		},
		init = function()
			vim.cmd([[cab cc CodeCompanion]])
		end,
		opts = {
			extensions = {
				history = {
					enabled = true,
					opts = {
						keymap = "gh",
						save_chat_keymap = "sc",
						auto_save = false,
						auto_generate_title = true,
						continue_last_chat = false,
						delete_on_clearing_chat = false,
						picker = "snacks",
						enable_logging = false,
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					},
				},
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
				vectorcode = {
					opts = { add_tool = true },
				},
			},
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4",
					},
					roles = { user = "eduuh" },
					keymaps = {
						send = { modes = { i = { "<C-CR>", "<C-s>" } } },
						completion = { modes = { i = "<C-x>" } },
					},
					slash_commands = {
						["buffer"] = { keymaps = { modes = { i = "<C-b>" } } },
						["fetch"] = { keymaps = { modes = { i = "<C-f>" } } },
						["help"] = { opts = { max_lines = 1000 } },
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = "gpt-4.1",
					},
				},
			},
			display = {
				action_palette = { provider = "default" },
				chat = { icons = { tool_success = "󰸞" } },
				diff = { provider = "mini_diff" },
			},
			opts = {
				log_level = "DEBUG",
			},
		},
	},
}
