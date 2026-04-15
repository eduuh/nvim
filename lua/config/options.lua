---@diagnostic disable: undefined-global
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.showtabline = 0

vim.opt.scrolloff = 5
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.signcolumn = "yes:1"
vim.opt.mouse = "a"
vim.opt.clipboard = { "unnamedplus" }
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.shortmess:append("cFWaIT")
vim.opt.swapfile = false
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = " ",
}
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.confirm = true
vim.opt.updatetime = 250

-- Load project-local .nvim.lua from the current dir and any ancestor (Nvim 0.12).
vim.opt.exrc = true

-- Nvim 0.12: unified float borders + native popup menu styling.
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.pummaxwidth = 80

-- Word-level inline diff highlights (indent-heuristic + inline:char are default).
vim.opt.diffopt:append("inline:word")

-- Show LSP progress in cmdline message area.
vim.opt.messagesopt = "hit-enter,history:500,progress:c"

-- render-markdown.nvim needs concealment to actually hide raw syntax.
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

-- Treesitter-based folding (Nvim 0.11+ ships the foldexpr).
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

vim.opt.undofile = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

-- Diagnostics: virtual lines on the current diagnostic's row is a big
-- readability win over default virtual_text. Toggle with <leader>ud.
vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = false,
  severity_sort = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

-- Per-filetype textwidth instead of forcing 80 cols on every buffer.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})
