return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "VeryLazy",
	config = true,
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
		{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
		{
			"<leader>xT",
			"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
			desc = "Todo/Fix/Fixme (Trouble)",
		},
	},
}
