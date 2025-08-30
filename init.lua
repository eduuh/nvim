require("config.options")
require("config.lazy")

vim.keymap.set({ "i", "n" }, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({ "n", "v" }, "<BS>", "<C-^>")
vim.keymap.set("n", ";n", ":cnext<CR>")
vim.keymap.set("n", ";p", ":cprev<CR>")
vim.keymap.set("n", ";s", ":Documented<CR>", { silent = true })
