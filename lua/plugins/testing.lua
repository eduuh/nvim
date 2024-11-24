local M = {}

function M.setup()
	require("neotest").setup({
		log_level = vim.log.levels.TRACE,
		adapters = {
			require("rustaceanvim.neotest"),
			require("neotest-plenary"),
			require("neotest-gtest"),
			require("neotest-jest"),
		},
	})
end

return {
	"tpope/vim-dispatch",
	{
		"vim-test/vim-test",
		ft = { "rust", "typescript", "javascript" },
		event = "VeryLazy",
		config = function()
			vim.cmd([[
      let test#strategy = {
      \ 'nearest': 'neovim',
      \ 'file':    'dispatch',
      \ 'suite':   'basic',
    \}

      nmap <silent> <leader>tt :TestNearest<CR>
      nmap <silent> <leader>tT :TestFile<CR>
      nmap <silent> <leader>ta :TestSuite<CR>
      nmap <silent> <leader>tl :TestLast<CR>
      nmap <silent> <leader>tv :TestVisit<CR>
    ]])
		end,
	},
	{
		"nvim-neotest/neotest",
		enabled = false,
		ft = { "rust", "typescript", "javascript" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"alfaix/neotest-gtest",
			"mrcjkb/rustaceanvim",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/neotest-plenary",
		},
		config = function()
			pcall(require, "nvim-treesitter")
			M.setup()
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
					require("neotest").summary.open()
				end,
				desc = "Run File",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
					require("neotest").summary.open()
				end,
				desc = "Run Nearest",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch",
			},
		},
	},
}
