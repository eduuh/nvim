return {
	"xeluxee/competitest.nvim",
	ft = { "cpp", "c", "cs", "typescript", "javascript", "rs", "rust", "js" },
	keys = {
		{ ";r", function() vim.cmd.CompetiTest("run") end, desc = "CompetiTest: run" },
		{ ";a", function() vim.cmd.CompetiTest("add_testcase") end, desc = "CompetiTest: add testcase" },
	},
	opts = {
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
			c = "~/.config/nvim/template/c.c",
			cpp = "~/.config/nvim/template/cpp.cpp",
			rust = "~/.config/nvim/template/rs.rs",
		},
		runner_ui = {
			interface = "popup",
		},
	},
}
