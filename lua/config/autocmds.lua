local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Per-filetype textwidth. Code formatters handle wrapping everywhere else.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- Re-balance splits when the terminal is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  pattern = "*",
  command = "wincmd =",
})
