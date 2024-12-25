--git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
--look at: https://github.com/polarmutex/git-worktree.nvim
return {
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},
	{
		"kdheepak/lazygit.nvim",
		event = "VeryLazy",
		keys = {
			{
				";c",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
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
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation

					map("n", "+", gs.next_hunk, { desc = "Next Hunk test, yes" })
					map("n", "-", gs.prev_hunk, { desc = "Prev Hunk" })

					-- Actions
					map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Stage Hunk" })
					map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
					map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset Line" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame Line" })
					map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle blame line" })
					map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diff" })
					map("n", "<leader>gh", "<cmd>DiffviewOpen<cr>", { desc = "Open diff" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "Open buffer diff" })
					map("n", "<leader>gx", gs.toggle_deleted, { desc = "Toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>:itsigns select_hunk<CR>", { desc = "Select Hunk (text objects)" })
				end,
			})
		end,
	},
}
