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
	vim.notify("File path copied: " .. entry.path)
end

local function get_cwd()
	local active_path = os.getenv("ACTIVE_PATH")

	if active_path and active_path ~= "" then
		local current_dir = vim.fn.getcwd()

		if string.find(current_dir, active_path, 1, true) then
			return active_path
		end
	end

	return vim.fn.getcwd()
end

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-tree/nvim-web-devicons",
		"BurntSushi/ripgrep",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		local custom_actions = transform_mod({
			open_trouble_qflist = function(_)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			extensions = {
				file_browser = {
					hijack_netrw = true,
					git_status = false,
					theme = "dropdown",
				},
			},
			pickers = {
				find_files = {
					case_mode = "ignore_case",
				},
				live_grep = {
					additional_args = function()
						return { "--ignore-case" }
					end,
				},
			},
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-p>"] = actions.move_selection_previous, -- move to prev result
						["<C-n>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
						["<C-y>"] = function()
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

		pcall(require("telescope").load_extension("fzf"))
		pcall(require("telescope").load_extension("file_browser"))
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({ cmd = get_cwd() })
			end,
			desc = "Find Files",
		},
		{
			"<leader>ft",
			"<cmd>TodoTelescope<cr>",
			desc = "Find Todos",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Open Buffer",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").registers()
			end,
			desc = "Open Buffer",
		},
		{
			";f",
			function()
				local builtin = require("telescope.builtin")
				builtin.find_files({
					no_ignore = false,
					hidden = true,
					cmd = get_cwd(),
				})
			end,
			desc = "Lists files in your current working directory, respects .gitignore",
		},
		{
			"<leader>fw",
			function()
				local builtin = require("telescope.builtin")
				builtin.grep_string({ cmd = get_cwd() })
			end,
			desc = "Find Word",
		},
		{
			"<leader>oq",
			function()
				local builtin = require("telescope.builtin")
				builtin.quickfix()
			end,
			desc = "List items in quick fix list",
		},
		{
			";w",
			function()
				local builtin = require("telescope.builtin")
				builtin.live_grep({ cmd = get_cwd() })
			end,
			desc = "Find string",
		},
		{
			"<leader>ot",
			function()
				local builtin = require("telescope.builtin")
				builtin.resume()
			end,
			desc = "Open telescope (resume)",
		},
		{
			"<leader>fd",
			function()
				local builtin = require("telescope.builtin")
				builtin.diagnostics({ cmd = get_cwd() })
			end,
			desc = "Lists Diagnostics for all open buffers or a specific buffer",
		},
		{
			"<leader>fs",
			function()
				local builtin = require("telescope.builtin")
				builtin.treesitter()
			end,
			desc = "Lists Function names, variablesf from Treesitter",
		},
		{
			";;",
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
		{
			";h",
			function()
				local telescope = require("telescope")

				telescope.extensions.file_browser.file_browser({
					path = "%:p:h",
					cwd = get_cwd(),
					respect_gitignore = false,
					hidden = true,
					grouped = true,
					previewer = false,
					initial_mode = "normal",
					layout_config = { height = 40 },
				})
			end,
			desc = "Open File Browser with the active path",
		},
	},
}
