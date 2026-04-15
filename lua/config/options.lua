---@diagnostic disable: undefined-global
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 3
vim.opt.showtabline = 1

vim.opt.textwidth = 80
vim.opt.scrolloff = 5
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.splitkeep = "cursor"
vim.opt.signcolumn = "yes"
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
vim.opt.backup = false
vim.opt.fillchars = { eob = " " }
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

-- Nvim 0.12: unified float borders + native popup menu styling
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.pummaxwidth = 80

-- Word-level inline diff highlights (indent-heuristic + inline:char are now default)
vim.opt.diffopt:append("inline:word")

-- Show LSP progress in cmdline message area
vim.opt.messagesopt = "hit-enter,history:500,progress:c"
vim.opt.conceallevel = 0
vim.opt.foldenable = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪\\"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd ="
})
