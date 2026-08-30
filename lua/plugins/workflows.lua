return {
	{
		"andythigpen/nvim-coverage",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"Coverage",
			"CoverageLoad",
			"CoverageLoadLcov",
			"CoverageToggle",
			"CoverageSummary",
			"CoverageClear",
		},
		keys = {
			{
				"<leader>cl",
				function()
					require("coverage").load(true)
				end,
				desc = "Coverage: load LCOV",
			},
			{
				"<leader>ct",
				function()
					require("coverage").toggle()
				end,
				desc = "Coverage: toggle signs",
			},
			{
				"<leader>cs",
				function()
					require("coverage").summary()
				end,
				desc = "Coverage: summary",
			},
		},
		opts = {
			auto_reload = false,
			lang = {
				javascript = { coverage_file = require("config.coverage").lcov_file },
				typescript = { coverage_file = require("config.coverage").lcov_file },
			},
		},
	},
	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		keys = {
			{
				"<leader>hr",
				function()
					require("kulala").run()
				end,
				mode = { "n", "v" },
				desc = "HTTP: run request",
			},
			{
				"<leader>hR",
				function()
					require("kulala").replay()
				end,
				desc = "HTTP: replay request",
			},
			{
				"<leader>hi",
				function()
					require("kulala").inspect()
				end,
				desc = "HTTP: inspect request",
			},
		},
		opts = {
			global_keymaps = false,
			kulala_keymaps = true,
			ui = {
				display_mode = "split",
				split_direction = "right",
			},
		},
	},
	{
		"tpope/vim-dadbod",
		cmd = { "DB" },
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod" },
		ft = { "sql", "mysql", "plsql" },
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Database UI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_help = 0
			vim.g.db_ui_winwidth = 40
		end,
	},
}
