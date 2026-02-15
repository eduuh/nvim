return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = {
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				"rust",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = "v",
					node_decremental = "V",
				},
			},
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.config").setup(opts)
		end,
	},
}
