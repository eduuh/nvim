vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Shared dependency libraries (consumed by many lazy.nvim plugins via `require`).
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
})

require("catppuccin").setup({
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
})
