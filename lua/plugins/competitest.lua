return {
	"xeluxee/competitest.nvim",
	ft = { "cpp", "c", "cs", "typescript", "javascript", "rs", "rust", "js" },
	dependencies = "MunifTanjim/nui.nvim",
	enabled = true,
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
			},
			compile_directory = ".",
			running_directory = ".",
			run_command = {
				c = { exec = "./$(FNOEXT)" .. ".out" },
				cpp = { exec = "./$(FNOEXT)" .. ".out" },
				rust = { exec = "./$(FNOEXT)" },
				javascript = { exec = "node", args = { "$(FNAME)" } },
				typescript = { exec = "ts-node", args = { "$(FNAME)" } },
			},
			template_file = {
				c = "~/.config/nvim/config_test/c++/template.cpp",
				cpp = "~/.config/nvim/config_test/c++/template.cpp",
				rust = "~/.config/nvim/config_test/rust/template.rs",
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
