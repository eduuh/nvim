return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
		{ "<leader>tt", function() vim.cmd.TodoFzfLua() end, desc = "TODO: search all" },
		{ "<leader>tf", function() vim.cmd.TodoFzfLua("keywords=TODO,FIX") end, desc = "TODO: TODOs & FIXes" },
	},
}
