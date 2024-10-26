return {
	{
		"anuvyklack/pretty-fold.nvim",
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
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "<leader>zo", require("ufo").openAllFolds)
			vim.keymap.set("n", "<leader>zf", require("ufo").closeAllFolds)

			-- Option 3: treesitter as a main provider instead
			-- (Note: the `nvim-treesitter` plugin is *not* needed.)
			-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
			-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
}
