-- Set leader key
vim.g.mapleader = " "

-- Encoding
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- UI & Display
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.wrap = false
vim.opt.textwidth = 80
vim.opt.scrolloff = 5
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.signcolumn = "yes"

-- Mouse & Clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = { "unnamedplus" }

-- Searching
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Tabs & Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }

-- Performance & Misc
vim.opt.shortmess:append("cFWaIT")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.fillchars = { eob = " " }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.conceallevel = 0
vim.opt.foldenable = false -- Using opt instead of o for consistency
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
