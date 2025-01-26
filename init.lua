require("config.osconfigs")
require("config.options")
require("config.lazy")
require("config.autocmd")
require("config.keymapping")
require("config.bash")

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})
