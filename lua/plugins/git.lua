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
				map("gn", function()
					gs.nav_hunk("next")
				end, "Gitsigns: next hunk")
				map("gp", function()
					gs.nav_hunk("prev")
				end, "Gitsigns: prev hunk")
				map("<leader>gp", gs.preview_hunk, "Gitsigns: preview hunk")
				map("gs", gs.stage_hunk, "Gitsigns: stage hunk")
				map("gu", gs.stage_hunk, "Gitsigns: unstage hunk (toggle)")
				map("gx", gs.toggle_deleted, "Gitsigns: toggle deleted")
				map("<leader>gr", gs.reset_hunk, "Gitsigns: reset hunk")
			end,
		},
	},
}
