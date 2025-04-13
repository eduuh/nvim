local keymap = vim.keymap.set
local map = require("config.utils").mapMany
local opts = { noremap = true, silent = true }

-- Single keys shortcuts
keymap({ "n", "v" }, "<BS>", "<C-^>", opts)

-- Control shortcuts
map({ "i", "n" }, "<C-q>", "<Esc>:q!<CR>", opts)
map({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

-- Split window
keymap("n", "<leader>h", ":split<Return>", opts)
keymap("n", "<leader>v", ":vsplit<Return>", opts)
