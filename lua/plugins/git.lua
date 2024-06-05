return {
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
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset Line" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame Line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame line" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Open diff" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Open buffer diff" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk (text objects)" })
				end,
			})
		end,
	},
}
