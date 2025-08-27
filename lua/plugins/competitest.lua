---@diagnostic disable: undefined-global
return {
  "xeluxee/competitest.nvim",
  ft = { "cpp", "c", "cs", "typescript", "javascript", "rs", "rust", "js" },
  dependencies = "MunifTanjim/nui.nvim",
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
        c = "~/.config/nvim/template/c.c",
        cpp = "~/.config/nvim/template/cpp.cpp",
        rust = "~/.config/nvim/template/rs.rs",
      },
      runner_ui = {
        interface = "popup",
      },
    })

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<leader>bc", "<cmd>CompetiTest run<cr>", opts)
    vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>CompetiTest run<cr>", opts)
    vim.api.nvim_set_keymap("n", "<leader>at", "<cmd>CompetiTest add_testcase<cr>", opts)
  end,
}
