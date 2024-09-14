local M = {}

M.isWin = vim.fn.has("win32") == 1
M.isMac = vim.fn.has("mac") == 1
M.isLinux = vim.fn.has("unix") == 1

M.isWSL = (vim.fn.has("wsl") == 1) or (vim.fn.system("uname -r"):find("WSL") ~= nil)

return M
