return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
		dependenciens = {
			"GustavEikaas/easy-dotnet.nvim",
		},
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "saecki/crates.nvim" },

		version = "*",

		opts = {
			keymap = { preset = "enter" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					auto_show = true,
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = true },
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "crates", "easy-dotnet" },
				cmdline = {},
				providers = {
					crates = {
						name = "crates",
						module = "blink.compat.source",
					},
					["easy-dotnet"] = {
						name = "easy-dotnet",
						module = "blink.compat.source",
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
