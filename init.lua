if vim.loader and vim.loader.enable then
	vim.loader.enable()
end

require("config.startup_profile").setup()
require("config.options")
require("config.pack")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
