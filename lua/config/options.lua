vim.g.mapleader = " "
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.shortmess:append("cFWaIT")

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"
vim.opt.textwidth = 80
vim.opt.showtabline = 0
vim.opt.laststatus = 0
vim.o.scrolloff = 5

vim.opt.conceallevel = 2

vim.o.signcolumn = "yes"
vim.opt.swapfile = false

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", {
	desc = "Prev buffer",
})

vim.keymap.set("n", "]b", "<cmd>bnext<cr>", {
	desc = "Next buffer",
})

vim.cmd([[
  augroup PopupInsertMode
    autocmd!
    autocmd FileType popupmenu inoremap <buffer> <C-q> <C-\><C-n>
  augroup END
]])

vim.opt.fillchars = { eob = " " }

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.clipboard = { "unnamedplus" }
