vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
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
