local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
-- vim.g.python3_host_prog = "~/.local/state/python3/bin/python3"
require("options")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = false },
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
})

require("keymapping")
require("autocmd")
require("ttconfig")

vim.api.nvim_set_keymap("n", ";", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ";", "<Nop>", { noremap = true, silent = true })

local isWin = vim.fn.has("win32")

if not isWin then
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end
