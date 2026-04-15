-- ─────────────────────────────────────────────────────────────────────────────
-- vim.pack-managed plugins.
--
-- Plugins here are eagerly loaded at startup because they either have no
-- meaningful lazy-loading value (always needed, colorscheme, libraries) or are
-- dependencies of plugins still managed by lazy.nvim. Everything else lives in
-- lua/plugins/*.lua (lazy.nvim).
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── Build hooks ─────────────────────────────────────────────────────────────
-- Post-install/update steps for plugins that need compilation. Registered
-- before vim.pack.add so it fires on the very first install.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "LuaSnip" then
      vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
    elseif name == "nvim-treesitter" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- ─── Specs ───────────────────────────────────────────────────────────────────
-- Order matters: plugins that are required by later setups (luasnip before
-- blink, treesitter before textobjects, mason before mason-tool-installer)
-- must appear first in the list.
vim.pack.add({
  -- Colorscheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Shared libraries consumed by many lazy.nvim plugins via `require`.
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/rafamadriz/friendly-snippets",

  -- Completion stack. LuaSnip is listed first because blink uses the luasnip
  -- preset and requires the module to be on rtp before its setup runs.
  -- blink.cmp is pinned to a v1.x tag so its prebuilt fuzzy-matching binary
  -- gets downloaded; the default branch expects you to `cargo build` yourself.
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("v2") },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },

  -- Treesitter is pinned to master. The new `main` branch is a breaking
  -- rewrite without the .configs module our setup uses. Upstream plans to
  -- archive master, so a follow-up migration is on the horizon.
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "master" },

  -- Core tooling & UI (always-needed; no lazy-loading value).
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/stevearc/conform.nvim",

  -- Small VeryLazy quality-of-life plugins; effectively eager after VimEnter.
  "https://github.com/echasnovski/mini.pairs",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/stevearc/overseer.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/folke/ts-comments.nvim",
})

-- ─── Colorscheme ─────────────────────────────────────────────────────────────
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

-- ─── Completion stack ────────────────────────────────────────────────────────
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

require("blink.cmp").setup({
  completion = {
    menu = {
      -- border comes from the global 'pumborder' option (Nvim 0.12).
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
  appearance = { nerd_font_variant = "mono" },
  signature = { enabled = false },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})

-- ─── Treesitter ──────────────────────────────────────────────────────────────
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript",
    "rust",
  },
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  },
})

-- ─── Mason ───────────────────────────────────────────────────────────────────
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

-- ─── Fzf-lua ─────────────────────────────────────────────────────────────────
do
  local fzf = require("fzf-lua")
  local actions = fzf.actions
  fzf.setup({
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    actions = {
      files = {
        ["enter"] = actions.file_edit_or_qf,
        ["ctrl-s"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-h"] = actions.toggle_hidden,
      },
    },
  })

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc })
  end
  map("<C-p>", fzf.files, "Files")
  map("<leader>ff", fzf.files, "Files")
  map("<leader>fw", fzf.live_grep, "Live grep")
  map("<leader>fo", fzf.oldfiles, "Recent files")
  map("<leader>fr", fzf.registers, "Registers")
  map("<leader>wd", fzf.diagnostics_workspace, "Workspace diagnostics")
  map("<leader>ql", fzf.quickfix, "Quickfix list")
  map("<leader>qs", fzf.quickfix_stack, "Quickfix stack")
end

-- ─── Statusline ──────────────────────────────────────────────────────────────
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

-- ─── Formatter ───────────────────────────────────────────────────────────────
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

-- ─── Small QoL plugins ───────────────────────────────────────────────────────
require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  skip_ts = { "string" },
  skip_unbalanced = true,
  markdown = true,
})

require("nvim-surround").setup()
require("overseer").setup()

require("ibl").setup({
  enabled = true,
  scope = { enabled = false },
  indent = { char = "▏" },
})

require("nvim-ts-autotag").setup()
require("ts-comments").setup()
