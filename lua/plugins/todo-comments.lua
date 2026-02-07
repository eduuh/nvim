return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
		{ "<leader>tt", "<cmd>TodoFzfLua<cr>", desc = "TODO: search all" },
		{ "<leader>tf", "<cmd>TodoFzfLua keywords=TODO,FIX<cr>", desc = "TODO: TODOs & FIXes" },
	},
}
