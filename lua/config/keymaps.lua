local map = vim.keymap.set

map({ "i", "n" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
map({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate buffer" })
map("n", ";n", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", ";p", "<cmd>cprev<CR>", { desc = "Prev quickfix" })
