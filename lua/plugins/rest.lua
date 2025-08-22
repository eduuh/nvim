return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "tree-sitter-http" },
    },
  },
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>rr", "<cmd>lua require('kulala').run()<cr>",         desc = "Run request" },
      { "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>",   desc = "Run request" },
      { "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>",   desc = "Run request" },
      { "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>",     desc = "Run request" },
      { "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Run request" },
      { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>",        desc = "Run request" },
      { "<leader>ri", "<cmd>lua require('kulala').from_curl()<cr>",   desc = "Run request" },
    },
  },
}
