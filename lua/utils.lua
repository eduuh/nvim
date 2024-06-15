local M = {}

-- Check if running on Windows or macOS
local isWinOrMac = vim.fn.has("win32") == 1 or vim.fn.has("mac") == 1

-- Check if running in Codespaces
local isCodespace = os.getenv("CODESPACES") ~= nil

-- Enable only if on Windows or macOS and not in Codespaces
M.isEnabled = isWinOrMac and not isCodespace

return M
