-- Resolve the repo's default branch so "diff my branch against the base" works
-- without hardcoding a name per repo. Prefers origin/HEAD, then the usual
-- suspects, and returns nil when none of them exist (detached/bare/no remote).
local function base_branch()
	local head = vim.system({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, { text = true }):wait()
	if head.code == 0 and head.stdout ~= "" then
		return vim.trim(head.stdout)
	end
	for _, name in ipairs({ "origin/main", "origin/master", "main", "master" }) do
		local rev = vim.system({ "git", "rev-parse", "--verify", "--quiet", name }, { text = true }):wait()
		if rev.code == 0 then
			return name
		end
	end
	return nil
end

local function open(args)
	vim.cmd("DiffviewOpen " .. (args or ""))
end

return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	opts = {
		enhanced_diff_hl = true,
		view = {
			default = { layout = "diff2_horizontal" },
			file_history = { layout = "diff2_horizontal" },
		},
	},
	keys = {
		{ "<leader>vd", function() open() end, desc = "Diffview: working tree" },
		{ "<leader>vs", function() open("--cached") end, desc = "Diffview: staged (index vs HEAD)" },
		{
			"<leader>vm",
			function()
				local base = base_branch()
				if not base then
					vim.notify("Diffview: no base branch found (origin/HEAD, main, master)", vim.log.levels.WARN)
					return
				end
				-- `base...HEAD` diffs against the merge base, so unrelated commits
				-- landing on the base branch don't show up as your changes.
				-- --imply-local keeps the right-hand side the real editable file.
				open(base .. "...HEAD --imply-local")
			end,
			desc = "Diffview: branch vs base merge-base",
		},
		{
			"<leader>vf",
			function()
				local file = vim.fn.expand("%:p")
				if file == "" then
					vim.notify("Diffview: current buffer has no file", vim.log.levels.WARN)
					return
				end
				open("-- " .. vim.fn.fnameescape(file))
			end,
			desc = "Diffview: current file only",
		},
		{
			"<leader>vr",
			function()
				vim.ui.input({ prompt = "git diff (rev or range): " }, function(input)
					if input and input ~= "" then
						open(input)
					end
				end)
			end,
			desc = "Diffview: prompt for rev/range",
		},
		{ "<leader>vh", function() vim.cmd.DiffviewFileHistory("%") end, desc = "Diffview: file history" },
		{ "<leader>vb", function() vim.cmd.DiffviewFileHistory() end, desc = "Diffview: branch history" },
		{ "<leader>vc", function() vim.cmd.DiffviewClose() end, desc = "Diffview: close" },
	},
}
