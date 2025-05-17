local utils = require("config.utils")
local mapMany = utils.mapMany
local map = utils.map
local opts = { noremap = true, silent = true }

mapMany({ "n", "v" }, "<BS>", "<C-^>", opts)

mapMany({ "i", "n" }, "<C-q>", "<Esc>:q!<CR>", opts)
mapMany({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

map("n", "<leader>h", ":split<Return>", "Split window horizontally")
map("n", "<leader>v", ":vsplit<Return>", "Split window vertically")
