local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=main",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = false },
	change_detection = {
		-- Set to false to disable checking for file changes
		enabled = false,
		notify = false,
	},
	install = {
		-- Don't automatically install missing plugins
		missing = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- Reset the package path to improve startup time
		rtp = {
			reset = true, -- Reset the runtime path to improve startup time
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"shada",
				"rplugin",
				"spellfile",
				"man",
			},
		},
	},
})
