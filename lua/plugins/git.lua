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
				on_attach = function(bufnr)
					local map = vim.keymap.set
					local buf = { buffer = bufnr }
					map("n", "<leader>gc", "<cmd>lua require'fzf-lua'.git_commits()<CR>", buf)
					map("n", "<leader>gb", "<cmd>lua require'fzf-lua'.git_branches()<CR>", buf)
					map("n", "<leader>gs", "<cmd>lua require'fzf-lua'.git_stash()<CR>", buf)
					map("n", "gb", "<cmd>Gitsigns blame_line<cr>", buf)
					map("n", "gB", "<cmd>Gitsigns blame<cr>", buf)
					map("n", "gn", "<cmd>Gitsigns next_hunk<cr>", buf)
					map("n", "gp", "<cmd>Gitsigns prev_hunk<cr>", buf)
					map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", buf)
					map("n", "gs", "<cmd>Gitsigns stage_hunk<cr>", buf)
					map("n", "gu", "<cmd>Gitsigns undo_stage_hunk<cr>", buf)
					map("n", "gx", "<cmd>Gitsigns toggle_deleted<cr>", buf)
					map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", buf)
				end,
			})
		end,
	},
}
