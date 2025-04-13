return {
	"HakonHarnes/img-clip.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {
		default = {
			use_absolute_path = false, ---@type boolean
			relative_to_current_file = true, ---@type boolean
			dir_path = function()
				return vim.fn.expand("%:t:r") .. "-img"
			end,

			prompt_for_file_name = false, ---@type boolean
			file_name = "%Y-%m-%d-at-%H-%M-%S", ---@type string
		},

		filetypes = {
			markdown = {
				url_encode_path = true, ---@type boolean
				template = "![$FILE_NAME]($FILE_PATH)", ---@type string
			},
		},
	},
	keys = {
		{
			"<C-a>",
			function()
				local pasted_image = require("img-clip").paste_image()
				if pasted_image then
					vim.cmd("update")
					print("Image pasted and file saved")
					vim.cmd([[lua require("image").clear()]])
					vim.cmd("edit!")
					vim.cmd("stopinsert")
				else
					print("No image pasted. File not updated.")
				end
			end,
			desc = "Paste image from system clipboard",
		},
	},
}
