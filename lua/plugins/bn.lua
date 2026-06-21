-- bn.nvim — the human cockpit over the `bn` engine, sourced from the bn repo.
--
-- Loads from the submodule at ~/.bin/bn-repo/nvim — the same main-tracking deployment the
-- tmux bindings use (bumped to main via the dotfiles submodule). That keeps the plugin
-- stable regardless of which branch a dev worktree (~/projects/bn) happens to be on.
-- Async + JSON-driven; see ~/.bin/bn-repo/nvim/README.md.
return {
	dir = vim.fn.expand("~/.bin/bn-repo/nvim"),
	name = "bn-nvim",
	dependencies = { "ibhagwan/fzf-lua" },
	event = "VeryLazy",
	config = function()
		require("bn").setup() -- uses `bn` on PATH (the live dispatcher)
	end,
}
