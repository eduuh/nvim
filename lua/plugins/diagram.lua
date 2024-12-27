return {
	"3rd/diagram.nvim",
	enabled = require("config.utils").isMac,
	dependencies = {
		"3rd/image.nvim",
	},
	opts = { -- you can just pass {}, defaults below
		renderer_options = {
			mermaid = {
				background = "transparent", -- nil | "transparent" | "white" | "#hex"
				theme = "dark", -- nil | "default" | "dark" | "forest" | "neutral"
				scale = 1, -- nil | 1 (default) | 2  | 3 | ...
				width = nil, -- nil | 800 | 400 | ...
				height = nil, -- nil | 600 | 300 | ...
			},
			plantuml = {
				charset = nil,
			},
			d2 = {
				theme_id = nil,
				dark_theme_id = nil,
				scale = nil,
				layout = nil,
				sketch = nil,
			},
		},
	},
}
