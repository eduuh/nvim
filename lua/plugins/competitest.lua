return {
	"xeluxee/competitest.nvim",
	ft = { "cpp", "c", "cs", "typescript", "javascript", "rs", "rust" },
	dependencies = "MunifTanjim/nui.nvim",
	enabled = require("utils").isEnabled,
	config = function()
		require("competitest").setup({
			testcases_use_single_file = true,
			compile_command = {
				c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" .. ".out" } },
				cpp = {
					exec = "clang++",
					args = { "-std=c++2a", "$(FNAME)", "-o", "$(FNOEXT)" .. ".out", "--debug" },
				},
				rust = { exec = "rustc", args = { "$(FNAME)" } },
				-- Todo add c# + js + ts
			},
			compile_directory = ".",
			running_directory = ".",
			run_command = {
				c = { exec = "./$(FNOEXT)" .. ".out" },
				cpp = { exec = "./$(FNOEXT)" .. ".out" },
				rust = { exec = "./$(FNOEXT)" },
				javascript = { exec = "node", "$(FNAME)" .. ".js" },
				typescript = { exec = "bun", "$(FNAME)" .. ".ts" },
			},
			runner_ui = {
				interface = "popup",
			},
		})

		local map = vim.keymap.set
		map({ "n", "v" }, "<leader>rc", "<cmd>CompetiTest run<cr>", { desc = "Run Code" })
		map({ "n", "v" }, "<leader>at", "<cmd>CompetiTest add_testcase<cr>", { desc = "Add Test cases" })
	end,
}
