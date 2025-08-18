---@diagnostic disable: undefined-global
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", opts)

return {
  "tpope/vim-dispatch",
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = function()
      require("overseer").setup()
    end,
  },
  {
    "vim-test/vim-test",
    enabled = true,
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
    "kylechui/nvim-surround",
    config = true,
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
