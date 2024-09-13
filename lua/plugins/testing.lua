local M = {}

function M.setup()
	require("neotest-gtest").setup({})
	require("neotest").setup({
		adapters = {
			require("rustaceanvim.neotest"),
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = function(file)
					if string.find(file, "/packages/") then
						return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
					end

					return vim.fn.getcwd() .. "/jest.config.ts"
				end,
				env = { CI = true },
				cwd = function(file)
					if string.find(file, "/packages/") then
						return string.match(file, "(.-/[^/]+/)src")
					end
					return vim.fn.getcwd()
				end,
			}),
		},
	})
end

return {
	"nvim-neotest/neotest",
	ft = { "rust", "typescript", "javascript" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"alfaix/neotest-gtest",
		"mrcjkb/rustaceanvim",
		"nvim-neotest/neotest-jest",
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
}
