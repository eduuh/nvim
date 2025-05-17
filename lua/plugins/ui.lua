---@diagnostic disable: undefined-global
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", opts)

return {
	{
		"stevearc/overseer.nvim",
		event = "VeryLazy",
		config = function()
			require("overseer").setup()
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		},
	},
	{ "mbbill/undotree" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require("onedark").setup({
				style = "warmer",
			})
			require("onedark").load()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			enabled = true,
			scope = {
				enabled = false,
			},
			indent = {
				char = "▏",
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/snacks.nvim",
		enabled = false,
		opts = {
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = false },
			words = { enabled = true },
			picker = { enabled = true },
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},
}
