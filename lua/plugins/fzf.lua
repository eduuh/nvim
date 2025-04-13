return {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"junegunn/fzf",
	},
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup()

		--Most Usefull keybinding
		local map = require("config.utils").map
		map("n", "<leader>fs", "<cmd>lua require'fzf-lua'.lsp_document_symbols()<CR>")
		map("n", "<leader>ts", "<cmd>lua require'fzf-lua'.treesitter()<CR>")
		map("n", "<leader>ws", "<cmd>lua require'fzf-lua'.lsp_workspace_symbols()<CR>")
		map("n", "<leader>wd", "<cmd>lua require'fzf-lua'.diagnostics_workspace()<CR>")
		map("n", "<leader>ff", "<cmd>lua require'fzf-lua'.files()<CR>")
		map("n", "<leader>fw", "<cmd>lua require'fzf-lua'.live_grep()<CR>")
		map("n", "<leader>fo", "<cmd>lua require'fzf-lua'.oldfiles()<CR>")
		map("n", "<leader>fr", "<cmd>lua require'fzf-lua'.registers()<CR>")
		map("n", "<leader>fb", "<cmd>lua require'fzf-lua'.buffers()<CR>")
		--Most usefull keybiding

		map("n", "<leader>ql", "<cmd>lua require'fzf-lua'.quickfix()<CR>")
		map("n", "<leader>qs", "<cmd>lua require'fzf-lua'.quickfix_stack()<CR>")
	end,
}
