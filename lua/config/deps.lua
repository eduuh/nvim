-- Single source of truth for the tools this config expects to exist.
--
-- lua/config/pack.lua feeds these to mason-tool-installer and
-- tree-sitter-manager; bootstrap.lua installs and then verifies the
-- same lists headlessly, so `install-deps.sh` can fail loudly instead
-- of leaving a half-provisioned machine.

return {
  -- mason package names (`:Mason` names, not lspconfig names).
  mason = {
    -- LSP servers
    "lua-language-server",
    "css-lsp",
    "bash-language-server",
    "marksman",
    "typescript-language-server",
    "eslint-lsp",
    "clangd",
    -- Formatters & linters
    "prettier",
    "prettierd",
    "stylua",
    "eslint_d",
    "clang-format",
    -- Debug adapters
    "js-debug-adapter",
    "codelldb",
  },

  -- tree-sitter parsers built by tree-sitter-manager.nvim.
  treesitter = {
    "bash",
    "c",
    "cpp",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },

  -- External binaries the config shells out to. `required` entries break
  -- startup or a core workflow when absent.
  binaries = {
    { cmd = "git", required = true, why = "vim.pack, lazy.nvim and parser clones" },
    { cmd = "cc", required = true, why = "compiling tree-sitter parsers" },
    { cmd = "make", required = true, why = "LuaSnip jsregexp" },
    { cmd = "tree-sitter", required = true, why = "tree-sitter-manager parser builds" },
    { cmd = "node", required = true, why = "magenta.nvim and the npm-based mason tools" },
    { cmd = "npm", required = true, why = "magenta.nvim build hook" },
    { cmd = "rg", required = false, why = "fzf-lua live grep" },
    { cmd = "fzf", required = false, why = "fzf-lua" },
    { cmd = "fd", required = false, why = "fzf-lua file listing" },
    { cmd = "cmake", required = false, why = "cmake-tools.nvim" },
    { cmd = "shfmt", required = false, why = "conform sh formatter" },
    { cmd = "cargo", required = false, why = "rustaceanvim / crates.nvim" },
    { cmd = "lazygit", required = false, why = "toggleterm lazygit terminal" },
  },
}
