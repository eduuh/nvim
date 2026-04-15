-- Build hooks: run post-install/update steps for plugins that need compilation.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then return end
    if name == "LuaSnip" then
      vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Shared dependency libraries (consumed by many lazy.nvim plugins via `require`).
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/rafamadriz/friendly-snippets",

  -- Completion stack: LuaSnip before blink.cmp (blink uses the luasnip preset).
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("v2") },
  "https://github.com/saghen/blink.cmp",

  -- Core tooling & UI (always-needed; no lazy-loading value).
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/stevearc/conform.nvim",
})

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    diffview = true,
    indent_blankline = { enabled = true },
    mason = true,
    render_markdown = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
  },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

require("blink.cmp").setup({
  completion = {
    menu = {
      -- border handled by global 'pumborder' option (Nvim 0.12)
      winblend = 10,
      max_height = 15,
      draw = {
        padding = 1,
        gap = 2,
        columns = {
          { "kind_icon", "kind", gap = 1 },
          { "label", "label_description", gap = 2 },
        },
        treesitter = { "lsp" },
      },
    },
  },
  snippets = { preset = "luasnip" },
  keymap = {
    preset = "enter",
    ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  signature = { enabled = false },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    -- LSP servers
    "lua-language-server",
    "css-lsp",
    "bash-language-server",
    "marksman",
    -- Formatters & linters
    "prettier",
    "prettierd",
    "stylua",
    "eslint_d",
    "clang-format",
  },
})

require("fzf-lua").setup({
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  actions = {
    files = {
      ["enter"] = require("fzf-lua").actions.file_edit_or_qf,
      ["ctrl-s"] = require("fzf-lua").actions.file_split,
      ["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
      ["ctrl-h"] = require("fzf-lua").actions.toggle_hidden,
    },
  },
})
do
  local map = vim.keymap.set
  map("n", "<leader>wd", "<cmd>lua require'fzf-lua'.diagnostics_workspace()<CR>")
  map("n", "<C-p>", "<cmd>lua require'fzf-lua'.files()<CR>")
  map("n", "<leader>ff", "<cmd>lua require'fzf-lua'.files()<CR>")
  map("n", "<leader>fw", "<cmd>lua require'fzf-lua'.live_grep()<CR>")
  map("n", "<leader>fo", "<cmd>lua require'fzf-lua'.oldfiles()<CR>")
  map("n", "<leader>fr", "<cmd>lua require'fzf-lua'.registers()<CR>")
  map("n", "<leader>ql", "<cmd>lua require'fzf-lua'.quickfix()<CR>")
  map("n", "<leader>qs", "<cmd>lua require'fzf-lua'.quickfix_stack()<CR>")
end

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      { "filename", path = 1 },
      { function() return vim.ui.progress_status() or "" end },
    },
    lualine_x = {
      { function() return vim.diagnostic.status() or "" end },
      "diagnostics",
    },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cmake = { "cmake-format" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    rust = { "rustfmt", lsp_format = "fallback" },
    html = { "prettier" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
