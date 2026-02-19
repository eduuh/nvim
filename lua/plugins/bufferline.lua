return {
	"akinsho/bufferline.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			show_buffer_close_icons = false,
			show_close_icon = false,
			separator_style = "thin",
			offsets = {
				{
					filetype = "undotree",
					text = "Undo Tree",
					highlight = "Directory",
					separator = true,
				},
			},
		},
	},
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
	},
}
