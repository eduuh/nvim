return {
	{
		"akinsho/toggleterm.nvim",
		keys = [[<c-n>]],
		cmd = { "ToggleTerm", "TermExec" },
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-n>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = false,
				direction = "float",
				close_on_exit = true,
				shell = "bash",
				float_opts = {
					border = "rounded",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
				winbar = {
					enabled = true,
					name_formatter = function(term)
						return term.count
					end,
				},
			})
		end,
	},
}
