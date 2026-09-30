return {
	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		-- A workspace that ships @typescript/native gets tsgo instead (see
		-- lua/config/tsgo.lua). Loading both would put two JS tsserver processes on
		-- a repo where they cannot finish, so only one TS server is ever started.
		cond = function()
			return require("config.tsgo").find(vim.fn.getcwd()) == nil
		end,
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
