return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{
				";c",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					delete = { text = "-" },
					change = { text = "+" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function()
					local map = vim.keymap.set
					map("n", "<leader>gc", "<cmd>lua require'fzf-lua'.git_commits()<CR>")
					map("n", "<leader>gb", "<cmd>lua require'fzf-lua'.git_branches()<CR>")
					map("n", "<leader>gs", "<cmd>lua require'fzf-lua'.git_stash()<CR>")
					map("n", "gb", "<cmd>Gitsigns blame_line<cr>")
					map("n", "gB", "<cmd>Gitsigns blame<cr>")
					map("n", "gn", "<cmd>Gitsigns next_hunk<cr>")
					map("n", "gp", "<cmd>Gitsigns next_prev<cr>")
					map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>")
					map("n", "gs", "<cmd>Gitsigns stage_hunk<cr>")
					map("n", "gu", "<cmd>Gitsigns undo_stage_hunk<cr>")
					map("n", "gx", "<cmd>Gitsigns toggle_deleted<cr>")
					map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
				end,
			})
		end,
	},
}
