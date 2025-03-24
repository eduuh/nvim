local M = {}

M.isWin = vim.fn.has("win32") == 1
M.isMac = vim.fn.has("mac") == 1
M.isLinux = vim.fn.has("unix") == 1

M.isWSL = (vim.fn.has("wsl") == 1) or (vim.fn.system("uname -r"):find("WSL") ~= nil)
M.isCodeSpace = os.getenv("CODESPACES")

M.map = function(modes, lhs, rhs, opts)
	for _, mode in ipairs(modes) do
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

M.ignore_filetypes = {
	"PlenaryTestPopup",
	"help",
	"lspinfo",
	"notify",
	"qf",
	"spectre_panel",
	"startuptime",
	"tsplayground",
	"neotest-output",
	"checkhealth",
	"neotest-summary",
	"neotest-output-panel",
	"dbout",
	"gitsigns.blame",
	"gitsigns.diff",
	"gitcommit",
}

return M
