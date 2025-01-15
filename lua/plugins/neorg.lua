return {
	"nvim-neorg/neorg",
	enabled = true,
	event = "VeryLazy",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/projects/byte_safari/content/",
						},
					},
				},
			},
		})
	end,
}
