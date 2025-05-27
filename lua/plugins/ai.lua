---@diagnostic disable: undefined-global
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = false,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        -- copilot_node_command = "node",
        server_opts_overrides = {},
      })
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 37373,
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
      })
    end,
  },
  {
    "yetone/avante.nvim",
    cmd = "Avante",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    build = "make",
    opts = { provider = "copilot" },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      agent = "copilot",
      debug = false,
      model = "claude-3.7-sonnet",
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
    },
    keys = {
      { "<leader>c",  ":CopilotChatToggle<CR>",       desc = "Copilot toggle" },
      { "<leader>cc", ":CopilotChatCommitStaged<CR>", desc = "Copilot create staged" },
      { "<leader>co", ":CopilotChatOptimize<CR>",     desc = "Copilot create staged" },
      { "<leader>cr", ":CopilotChatReview<CR>",       desc = "Copilot create staged" },
      { "<leader>ce", ":CopilotChatExplain<CR>",      desc = "Copilot create staged" },
      {
        "<leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
          end
        end,
        desc = "CopilotChat - Quick chat selected",
        mode = { "v" },
      },
    },
  },
}
