-- The editor half of the nvim MCP server: this plugin registers a socket named after the git
-- root, and `nvim-mcp --connect auto` (wired for Claude Code and both Copilots by bn's install.sh)
-- discovers it from there. Without the plugin loaded there is simply nothing for an agent to find.
return {
  "linw1995/nvim-mcp",
  -- Never lazy. The socket has to exist for a session an agent might attach to, and an editor
  -- that defers loading until some keymap fires is invisible to discovery until then.
  lazy = false,
  -- Builds the server from THIS checkout rather than taking it from crates.io, and that is the
  -- whole point: the two halves must come from the same commit. Released 0.7.2 globs /tmp for
  -- sockets while the plugin on main registers them under $XDG_RUNTIME_DIR, so a mismatched pair
  -- discovers nothing and reports it as "no editor open". lazy-lock.json pins the commit and this
  -- build re-runs on update, so they stay in step. (install-deps.sh already ensures cargo.)
  build = "cargo install --path .",
  config = function()
    require("nvim-mcp").setup({})
  end,
}
