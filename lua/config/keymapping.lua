local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set({ "n", "v" }, "<BS>", "<C-^>", { desc = "Alternate File" })

keymap.set("n", "x", '"_x')

-- Increment/decrement
-- keymap.set("n", "+", "<C-a>")
-- keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Split window
keymap.set("n", "<leader>h", ":split<Return>", opts)
keymap.set("n", "<leader>v", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

vim.api.nvim_set_keymap("n", "s", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "s", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ";", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ";", "<Nop>", { noremap = true, silent = true })
