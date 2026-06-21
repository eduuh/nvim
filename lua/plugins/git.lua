return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				delete = { text = "-" },
				change = { text = "+" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local fzf = require("fzf-lua")
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("<leader>gc", fzf.git_commits, "Git: commits")
				map("<leader>gb", fzf.git_branches, "Git: branches")
				map("<leader>gs", fzf.git_stash, "Git: stash")

				map("gb", gs.blame_line, "Gitsigns: blame line")
				map("gB", gs.blame, "Gitsigns: blame")
				map("gn", gs.next_hunk, "Gitsigns: next hunk")
				map("gp", gs.prev_hunk, "Gitsigns: prev hunk")
				map("<leader>gp", gs.preview_hunk, "Gitsigns: preview hunk")
				map("gs", gs.stage_hunk, "Gitsigns: stage hunk")
				map("gu", gs.undo_stage_hunk, "Gitsigns: undo stage hunk")
				map("gx", gs.toggle_deleted, "Gitsigns: toggle deleted")
				map("<leader>gr", gs.reset_hunk, "Gitsigns: reset hunk")
			end,
		},
	},
}
