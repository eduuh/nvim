--git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
--look at: https://github.com/polarmutex/git-worktree.nvim
return {
	{
		"ThePrimeagen/git-worktree.nvim",
		event = "VeryLazy",
		config = function()
			require("git-worktree").setup({
				update_on_change = false,
				autopush = false,
				update_on_change_command = "if expand('%:t') != '' | e . | endif",
			})

			local opt = { noremap = true, silent = true }

			opt.desc = "Switch & delete worktrees"
			-- <Enter> - switches to that worktree
			-- <c-d> - deletes that worktree
			-- <c-f> - toggles forcing of the next deletion
			vim.keymap.set("n", "<leader>sw", function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end, opt)

			vim.keymap.set("n", "<leader>cw", function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end, opt)

			local Worktree = require("git-worktree")

			-- op = Operations.Switch, Operations.Create, Operations.Delete
			-- metadata = table of useful values (structure dependent on op)
			--      Switch
			--          path = path you switched to
			--          prev_path = previous worktree path
			--      Create
			--          path = path where worktree created
			--          branch = branch name
			--          upstream = upstream remote name
			--      Delete
			--          path = path where worktree deleted

			Worktree.on_tree_change(function(op, metadata)
				if op == Worktree.Operations.Switch then
					print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
				end
			end)
		end,
	},
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
