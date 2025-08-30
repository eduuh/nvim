return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"junegunn/fzf",
	},
	config = function()
		local fzf = require("fzf-lua")
		local actions = require("fzf-lua").actions

		fzf.setup({
			winopts = {
				ui_select = true,
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
				files = {
					["enter"] = actions.file_edit_or_qf,
					["ctrl-s"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
					["ctrl-h"] = actions.toggle_hidden,
				},
			},
		})
		local map = vim.keymap.set
		map("n", "<leader>wd", "<cmd>lua require'fzf-lua'.diagnostics_workspace()<CR>")
		map("n", "<C-p>", "<cmd>lua require'fzf-lua'.global({ resume = false })<CR>")
		map("n", "<leader>ff", "<cmd>lua require'fzf-lua'.global({ resume = false })<CR>")
		map("n", "<leader>fw", "<cmd>lua require'fzf-lua'.live_grep()<CR>")
		map("n", "<leader>fo", "<cmd>lua require'fzf-lua'.oldfiles()<CR>")
		map("n", "<leader>fr", "<cmd>lua require'fzf-lua'.registers()<CR>")
		map("n", "<leader>ql", "<cmd>lua require'fzf-lua'.quickfix()<CR>")
		map("n", "<leader>qs", "<cmd>lua require'fzf-lua'.quickfix_stack()<CR>")
	end,
}
