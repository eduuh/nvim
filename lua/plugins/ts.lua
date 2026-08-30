return {
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		keys = {
			{
				"<leader>nn",
				function()
					require("config.js_tests").run_nearest()
				end,
				desc = "Test nearest",
			},
			{
				"<leader>nd",
				function()
					require("config.js_tests").debug_nearest()
				end,
				desc = "Debug nearest test",
			},
			{
				"<leader>nf",
				function()
					require("config.js_tests").run_file()
				end,
				desc = "Test current file",
			},
			{
				"<leader>na",
				function()
					require("config.js_tests").run_project()
				end,
				desc = "Test project",
			},
			{
				"<leader>nw",
				function()
					require("config.js_tests").watch_nearest()
				end,
				desc = "Watch nearest test",
			},
			{
				"<leader>nW",
				function()
					require("config.js_tests").watch_file()
				end,
				desc = "Watch test file",
			},
			{
				"<leader>nr",
				function()
					require("config.js_tests").rerun_failed()
				end,
				desc = "Rerun failed tests",
			},
			{
				"<leader>rs",
				function()
					require("config.js_scripts").pick()
				end,
				desc = "Run package script",
			},
		},
		opts = {
			settings = {
				expose_as_code_action = "all",
				complete_function_calls = true,
				tsserver_file_preferences = {
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeInlayEnumMemberValueHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
				jsx_close_tag = {
					enable = true,
					filetypes = { "javascriptreact", "typescriptreact" },
				},
			},
		},
	},
}
