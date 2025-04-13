local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", opts)

return { "mbbill/undotree" }
