---@diagnostic disable: undefined-global
return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		mappings = {
			["gc"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			log_level = vim.log.levels.INFO,
		},
		workspaces = {
			{
				name = "personal",
				path = "~/projects/byte_s",
			},
			{
				name = "work",
				path = "~/projects/personal",
			},
		},
	},
}
