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

local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
local cfg = require("rustaceanvim.config")

vim.g.rustaceanvim = {
	dap = {
		adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
	},
	server = {
		default_settings = {
			["rust-analyzer"] = {},
		},
	},
}
