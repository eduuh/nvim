return {
	"saghen/blink.cmp",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},

	version = "*",

	opts = {
		completion = {
			menu = {
				-- border handled by global 'pumborder' option (Nvim 0.12)
				winblend = 10,
				max_height = 15,
				draw = {
					padding = 1,
					gap = 2,

					columns = {
						{ "kind_icon", "kind", gap = 1 },
						{ "label", "label_description", gap = 2 },
					},

					treesitter = { "lsp" }, -- colorize completion items using TS
				},
			},
		},

		snippets = { preset = "luasnip" },
		keymap = {
			preset = "enter",
			["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		signature = { enabled = false },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
