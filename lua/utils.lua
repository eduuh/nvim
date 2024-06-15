local M = {}

M.isEnabled = vim.fn.has("win32") == 1 or vim.fn.has("mac") == 1

return M
