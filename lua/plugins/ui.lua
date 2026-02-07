return {
	{ "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Focus", "Start" } },
	{
		"stevearc/overseer.nvim",
		event = "VeryLazy",
		config = function()
			require("overseer").setup()
		end,
	},
	-- {
	-- 	"vim-test/vim-test",
	-- 	ft = { "rust", "typescript", "javascript" },
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		vim.cmd([[
	--      let test#strategy = {
	--      \ 'nearest': 'neovim',
	--      \ 'file':    'dispatch',
	--      \ 'suite':   'basic',
	--    \}
	--      nmap <silent> <leader>tt :TestNearest<CR>
	--      nmap <silent> <leader>tT :TestFile<CR>
	--      nmap <silent> <leader>ta :TestSuite<CR>
	--      nmap <silent> <leader>tl :TestLast<CR>
	--      nmap <silent> <leader>tv :TestVisit<CR>
	--    ]])
	-- 	end,
	-- },
	{
		"echasnovski/mini.pairs",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		},
	},
	{
		"mbbill/undotree",
		config = function()
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }
			keymap("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", opts)
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1001,
		opts = {
			flavour = "mocha",
			integrations = {
				diffview = true,
				indent_blankline = { enabled = true },
				mason = true,
				render_markdown = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
		"kylechui/nvim-surround",
		event = "VeryLazy",
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
