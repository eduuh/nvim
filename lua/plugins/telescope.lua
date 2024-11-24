return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(_)
				trouble.toggle("quickfix")
			end,
		})

		local yank_path = function()
			local entry = require("telescope.actions.state").get_selected_entry()
			local cb_opts = vim.opt.clipboard:get()
			if vim.tbl_contains(cb_opts, "unnamed") then
				vim.fn.setreg("*", entry.path)
			end
			if vim.tbl_contains(cb_opts, "unnamedplus") then
				vim.fn.setreg("+", entry.path)
			end
			vim.fn.setreg("", entry.path)
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
						[";y"] = function()
							yank_path()
						end,
					},
					n = {
						["y"] = function()
							yank_path()
						end,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		pcall(require("telescope").load_extension("git_worktree"))
		pcall(require("telescope").load_extension("fzf"))
		pcall(require("telescope").load_extension("file_browser"))

		local opt = { noremap = true, silent = true }

		opt.desc = "Find Harpoon [M]arks"
		vim.keymap.set("n", "<leader>fm", ":Telescope harpoon marks<CR>", opt)
		opt.desc = "Find Files"
		vim.keymap.set("n", "<leader>ff", builtin.find_files, opt)
		vim.keymap.set("n", "sf", builtin.find_files, opt)
		opt.desc = "Find Help tags"
		vim.keymap.set("n", ";h", builtin.help_tags, opt)
		opt.desc = "[?] Find recently opened files"
		vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, opt)

		-- Enable telescope fzf native, if installed
		opt.desc = "[/] Fuzzily search in current buffer]"
		vim.keymap.set("n", "<leader>sb", function()
			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes"))
		end, opt)

		vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").registers, { desc = "Find Registers" })
		-- vim.keymap.set(
		-- 	"n"
		-- 	"<Leader>sr",
		-- 	"<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
		-- 	silent
		-- )
		-- vim.keymap.set(
		-- 	"n",
		-- 	"<Leader>sR",
		-- 	"<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
		-- 	silent
		-- )

		vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<CR>", { noremap = true, desc = "Search Todo" })
		vim.api.nvim_set_keymap(
			"n",
			"<Leader>fc",
			"<Cmd>lua require('telescope.builtin').commands()<CR>",
			{ noremap = false, desc = "Search Commands" }
		)
	end,
	keys = {
		{
			"sn",
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
			"<leader>fq",
			function()
				local builtin = require("telescope.builtin")
				builtin.quickfix()
			end,
			desc = "List items in quick fix list",
		},
		{
			"<leader>sw",
			function()
				local builtin = require("telescope.builtin")
				builtin.grep_string()
			end,
			desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
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
			desc = "Lists Function names, variablesf from Treesitter",
		},
		{
			"<leader>sf",
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
}
