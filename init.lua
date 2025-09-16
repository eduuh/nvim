require("config.options")
require("config.lazy")

vim.keymap.set({ "i", "n" }, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({ "n", "v" }, "<BS>", "<C-^>")
vim.keymap.set("n", ";n", ":cnext<CR>")
vim.keymap.set("n", ";p", ":cprev<CR>")
vim.keymap.set("n", ";s", ":Documented<CR>", { silent = true })

require("shellcmd").setup()
require("shellcmd").setup()
vim.keymap.set("n", "<leader>ss", "<cmd>ShellRunCell<CR>", { desc = "Run shell cell" })
vim.keymap.set("n", "<leader>so", "<cmd>ShellOutputOpen<CR>", { desc = "Open output in scratch buffer" })
