local M = {}

function M.setup()
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets"),
	})

	local luasnip = require("luasnip")
	local filetype_extensions = {
		javascriptreact = { "javascript" },
		typescript = { "javascript" },
		typescriptreact = { "javascript", "javascriptreact", "typescript" },
	}
	for filetype, extensions in pairs(filetype_extensions) do
		luasnip.filetype_extend(filetype, extensions)
	end

	vim.keymap.set("n", "<leader>se", function()
		require("luasnip.loaders").edit_snippet_files()
	end, { desc = "Edit snippets" })
end

return M
