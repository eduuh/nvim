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
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ "folke/neoconf.nvim", cmd = "Neoconf" },
		"folke/neodev.nvim",
		{ dir = "~/projects/local_plugins/rest.nvim", dependencies = { "j-hui/fidget.nvim" } },
	},
	dev = {
		path = "~/projects/local_plugins/",
		pattern = { "rest" },
	},
	checker = { enabled = false },
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				-- TODO: more from NcChad `lua/plugins/configs/lazy_nvim.lua`
				"gzip",
				"matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
