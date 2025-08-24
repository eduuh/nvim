local rust_tools = {}
function rust_tools.setup()
  local codelldb_root = vim.fn.stdpath("data") .. "/mason" .. "/packages/"
  local codelldb_path = codelldb_root .. "/codelldb"
  local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
  local cfg = require("rustaceanvim.config")
  vim.g.rustaceanvim = {
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    inlay_hints = {
      highlight = "NonText",
    },
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
    server = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  }
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = "rust",
    dependencies = { "mason-org/mason-registry" },
    config = function()
      rust_tools.setup()
    end,
  },
  {
    "saecki/crates.nvim",
    event = "VeryLazy",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },
  {
    "rust-lang/rust.vim",
    event = "VeryLazy",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
}
