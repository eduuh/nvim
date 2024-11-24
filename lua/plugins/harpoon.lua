return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>am",
			function()
				local harpoon = require("harpoon")
				harpoon:list():add()
			end,
			desc = "Add Marks",
		},
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({})
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>om", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open Marks" })

		vim.keymap.set("n", "<leader>em", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
	end,
}
