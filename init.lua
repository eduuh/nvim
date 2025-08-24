require("config.options")
require("config.lazy")

local utils = require("config.utils")
local mapMany = utils.mapMany
local opts = { noremap = true, silent = true }

mapMany({ "n", "v" }, "<BS>", "<C-^>", opts)
mapMany({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

vim.keymap.set("n", ";n", ":cnext<CR>", { noremap = true, silent = true, desc = "Quickfix next" })
vim.keymap.set("n", ";p", ":cprev<CR>", { noremap = true, silent = true, desc = "Quickfix previous" })
