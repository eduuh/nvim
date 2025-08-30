return {
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gb", "gcc", "gbc" },
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"isticusi/docpair.nvim",
		main = "docpair",
		lazy = false, -- eager so :Documented has filename completion immediately
		opts = { info_filetype = "markdown" },
		config = true, -- calls require("docpair").setup(opts)
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
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
			})
		end,
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
				config = function()
					require("mcphub").setup({
						port = 37373,
						config = vim.fn.stdpath("config") .. "/mcphub/servers.json",
					})
				end,
			},
		},
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
					opts = {
						add_tool = true,
					},
				},
			},
			adapters = {
				-- anthropic = function()
				-- 	return require("codecompanion.adapters").extend("anthropic", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
				-- deepseek = function()
				-- 	return require("codecompanion.adapters").extend("deepseek", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/DeepSeek_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
				-- gemini = function()
				-- 	return require("codecompanion.adapters").extend("gemini", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/Gemini_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
				-- mistral = function()
				-- 	return require("codecompanion.adapters").extend("mistral", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/Mistral_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
				-- novita = function()
				-- 	return require("codecompanion.adapters").extend("novita", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/Novita_API/credential --no-newline",
				-- 		},
				-- 		schema = {
				-- 			model = {
				-- 				default = function()
				-- 					return "meta-llama/llama-3.1-8b-instruct"
				-- 				end,
				-- 			},
				-- 		},
				-- 	})
				-- end,
				-- ollama = function()
				-- 	return require("codecompanion.adapters").extend("ollama", {
				-- 		schema = {
				-- 			model = {
				-- 				default = "qwen3:latest",
				-- 			},
				-- 			num_ctx = {
				-- 				default = 20000,
				-- 			},
				-- 		},
				-- 	})
				-- end,
				-- openai = function()
				-- 	return require("codecompanion.adapters").extend("openai", {
				-- 		opts = {
				-- 			stream = true,
				-- 		},
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/OpenAI_API/credential --no-newline",
				-- 		},
				-- 		schema = {
				-- 			model = {
				-- 				default = function()
				-- 					return "gpt-4.1"
				-- 				end,
				-- 			},
				-- 		},
				-- 	})
				-- end,
				-- xai = function()
				-- 	return require("codecompanion.adapters").extend("xai", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/xAI_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
				-- tavily = function()
				-- 	return require("codecompanion.adapters").extend("tavily", {
				-- 		env = {
				-- 			api_key = "cmd:op read op://personal/Tavily_API/credential --no-newline",
				-- 		},
				-- 	})
				-- end,
			},
			prompt_library = {
				["Edwin workflows"] = {
					strategy = "workflow",
					description = "Use a workflow to test the plugin",
					opts = {
						index = 4,
					},
					prompts = {
						{
							-- {
							--   {
							--     role = "user",
							--     content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
							--     opts = {
							--       auto_submit = true,
							--     },
							--   },
							-- },
						},
					},
				},
				strategies = {
					chat = {
						adapter = {
							name = "copilot",
							model = "claude-sonnet-4",
						},
						roles = {
							user = "eduuh",
						},
						keymaps = {
							send = {
								modes = {
									i = { "<C-CR>", "<C-s>" },
								},
							},
							completion = {
								modes = {
									i = "<C-x>",
								},
							},
						},
						slash_commands = {
							["buffer"] = {
								keymaps = {
									modes = {
										i = "<C-b>",
									},
								},
							},
							["fetch"] = {
								keymaps = {
									modes = {
										i = "<C-f>",
									},
								},
							},
							["help"] = {
								opts = {
									max_lines = 1000,
								},
							},
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
					action_palette = {
						provider = "default",
					},
					chat = {
						icons = {
							tool_success = "󰸞",
						},
					},
					diff = {
						provider = "mini_diff",
					},
				},
				opts = {
					log_level = "DEBUG",
				},
			},
			keys = {
				{
					"<C-a>",
					"<cmd>CodeCompanionActions<CR>",
					desc = "Open the action palette",
					mode = { "n", "v" },
				},
				{
					"<Leader>a",
					"<cmd>CodeCompanionChat Toggle<CR>",
					desc = "Toggle a chat buffer",
					mode = { "n", "v" },
				},
				{
					"<LocalLeader>a",
					"<cmd>CodeCompanionChat Add<CR>",
					desc = "Add code to a chat buffer",
					mode = { "v" },
				},
			},
			init = function()
				vim.cmd([[cab cc CodeCompanion]])
			end,
		},
	},
}
