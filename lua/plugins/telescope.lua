return {
	{
		"telescope.nvim",
		event = "VeryLazy",
		priority = 1000,
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>fn",
				"<cmd>ObsidianSearch<cr>",
				desc = "Find Notes",
			},
			{
				";;",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				desc = "File Explorer",
			},
			{
				";f",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
					})
				end,
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				"<leader>fw",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep()
				end,
				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
			},
			{
				";b",
				function()
					local builtin = require("telescope.builtin")
					builtin.buffers()
				end,
				desc = "Lists open buffers",
			},
			{
				";r",
				function()
					local builtin = require("telescope.builtin")
					builtin.resume()
				end,
				desc = "Resume the previous telescope picker",
			},
			{
				";e",
				function()
					local builtin = require("telescope.builtin")
					builtin.diagnostics()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				";s",
				function()
					local builtin = require("telescope.builtin")
					builtin.treesitter()
				end,
				desc = "Lists Function names, variables, from Treesitter",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")

					local function telescope_buffer_dir()
						return vim.fn.expand("%:p:h")
					end

					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = telescope_buffer_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Open File Browser with the path of the current buffer",
			},
		},
		config = function()
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", ";m", ":Telescope harpoon marks<CR>", { desc = "Harpoon [M]arks" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", ";h", builtin.help_tags, {})

			vim.keymap.set(
				"n",
				"<leader>o",
				require("telescope.builtin").oldfiles,
				{ desc = "[?] Find recently opened files" }
			)

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")

			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = true,
				}))
			end, { desc = "[/] Fuzzily search in current buffer]" })

			local silent = { silent = true }

			vim.keymap.set(
				"n",
				"<leader>sw",
				require("telescope.builtin").grep_string,
				{ desc = "[S]earch current [W]ord" }
			)
			vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set(
				"n",
				"<leader>sd",
				require("telescope.builtin").diagnostics,
				{ desc = "[S]earch [D]iagnostics" }
			)
			vim.keymap.set(
				"n",
				"<leader>sb",
				require("telescope.builtin").buffers,
				{ desc = "[ ] Find existing buffers" }
			)
			vim.keymap.set("n", "<leader>sS", require("telescope.builtin").git_status, { desc = "" })
			vim.keymap.set(
				"n",
				"<Leader>sr",
				"<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
				silent
			)
			vim.keymap.set(
				"n",
				"<Leader>sR",
				"<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
				silent
			)
			vim.keymap.set("n", "<Leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent)

			vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<CR>", { noremap = true })
			vim.api.nvim_set_keymap(
				"n",
				"<Leader><tab>",
				"<Cmd>lua require('telescope.builtin').commands()<CR>",
				{ noremap = false }
			)
		end,
	},
}
