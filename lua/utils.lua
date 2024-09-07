local M = {}

-- Check if running on Windows or macOS
local isWinOrMac = vim.fn.has("win32") == 1 or vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1

-- Check if running in Codespaces
local isCodespace = os.getenv("CODESPACES") ~= nil

isWindowsOrCodeSpace = vim.fn.has("win32") or isCodespace

-- Enable only if on Windows or macOS and not in Codespaces
M.isEnabled = isWinOrMac and not isCodespace

return M
