return {
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"anuvyklack/pretty-fold.nvim",
		event = "VeryLazy",
		config = function()
			require("pretty-fold").setup({
				keep_indentation = true,
				fill_char = "•",
				sections = {
					left = {
						"+",
						function()
							return string.rep("-", vim.v.foldlevel)
						end,
						" ",
						"number_of_folded_lines",
						":",
						"content",
					},
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "<leader>zo", require("ufo").openAllFolds)
			vim.keymap.set("n", "<leader>zf", require("ufo").closeAllFolds)

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
}
