return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"junegunn/fzf",
		"sharkdp/fd",
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup()

		vim.api.nvim_set_keymap(
			"n",
			"<leader>ff",
			"<cmd>lua require'fzf-lua'.files()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>fw",
			"<cmd>lua require'fzf-lua'.live_grep()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua browse_files()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>fr",
			"<cmd>lua require'fzf-lua'.registers()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>fd",
			"<cmd>lua require'fzf-lua'.diagnostics()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>fs",
			"<cmd>lua require'fzf-lua'.treesitter()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>oq",
			"<cmd>lua require'fzf-lua'.quickfix()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
