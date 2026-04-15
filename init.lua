require("config.options")
require("config.pack")
require("config.lazy")

vim.keymap.set({ "i", "n" }, "<C-s>", "<cmd>w<CR>", { desc = "Save buffer" })
vim.keymap.set({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate buffer" })
vim.keymap.set("n", ";n", "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", ";p", "<cmd>cprev<CR>", { desc = "Prev quickfix" })

vim.cmd([[colorscheme catppuccin]])
