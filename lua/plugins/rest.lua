return {
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>rr", function() require("kulala").run() end, desc = "Kulala: run request" },
			{ "<leader>rp", function() require("kulala").jump_prev() end, desc = "Kulala: prev request" },
			{ "<leader>rn", function() require("kulala").jump_next() end, desc = "Kulala: next request" },
			{ "<leader>ri", function() require("kulala").inspect() end, desc = "Kulala: inspect" },
			{ "<leader>rt", function() require("kulala").toggle_view() end, desc = "Kulala: toggle view" },
			{ "<leader>rc", function() require("kulala").copy() end, desc = "Kulala: copy as curl" },
			{ "<leader>rI", function() require("kulala").from_curl() end, desc = "Kulala: import from curl" },
		},
	},
}
